var express = require('express');
const fetch = require('node-fetch');
const mongo = require('../lib/mongo');
const pusher = require('../lib/pusher');
const wordBank = require('../public/words.json');
const {
  v4: uuidv4
} = require('uuid');

var router = express.Router();
const ACCESS_LENGTH_CODE = 4;
const NUM_CHOICES = 3;

// -----------------------------TESTING ENDPOINTS-------------------------------
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/mongo', (req, res) => {
  mongo.viewDB('group', (docs) => res.json(docs));
})

router.delete('/mongo', (req, res) => {
  mongo.clearCollection('group');
  res.send(200);
})

router.put('/rotate', async (req, res) => {
  let accessCode = req.body['accessCode'];
  let round = req.body['round'];

  let doc = await mongo.findDocument(accessCode, 'group');
  rotateDict(accessCode, doc['playerChosenWord'], doc['members'], parseInt(round));
  res.send(200);

})

// ---------------------------- REAL ENDPOINTS ---------------------------------

// Create a group
router.put('/create-group', async (req, res) => {
  // Parse body
  let groupName = req.body['groupName'];
  let name = req.body['name'];

  // If body does not have 'groupName' and 'name', return an error and exit
  if(!(groupName && name)){
    console.log(groupName, name);
    res.status(400).json({
      'message': 'Bad Request'
    });
    return;
  }

  // Generate an access code
  let accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);

  // Database Document
  let group = {
    'accessCode': accessCode,
    'groupName': groupName,
    'joinable': true,
    'members': [name],
    'playerToWord': {},
    'playerChosenWord' : {},
    'wordSketches': {},
    'wordGuesses': {},
    'submittedMembers': []
  };

  // keep generating accessCodes until a valid one is generated
  while (true) {
    // finds a doc with access code
    let doc = await mongo.findDocument(accessCode, 'group');
    // if doc does not exist
    if (doc == null) {
      // create the doc
      mongo.addDocument(group, 'group');
      break;
    }
    // retry access code
    accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);
    group['accessCode'] = accessCode;
  }
  // respond with the access code
  res.status(201).json({
    accessCode: accessCode
  });
});

// Join a group
router.put('/join-group', async (req, res) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];

  // finds group
  let doc = await mongo.findDocument(accessCode, 'group');

  // if group exists
  if (doc) {
    // if group is joinable
    if (doc['joinable']) {
      // if name is valid
      if (!doc['members'].includes(name)) {
        // add members
        await mongo.pushUpdate(accessCode, 'members', name, 'group');
        // get updated document
        doc = await mongo.findDocument(accessCode, 'group');

        // Send pusher triggerEvent
        pusher.triggerEvent(accessCode, 'onGuestJoin', doc['members']);
        res.status(200).json({
          'message': 'Success',
          'groupName': doc['groupName'],
          'members': doc['members'],
        });
      } else {
        res.status(409).json({
          'error': 'Name already exists!'
        });
      }
    }
    else {
      res.status(409).json({
        'error': 'Group is in progress!'
      });
    }
  }
  // if group does not exist
  else {
    res.status(400).json({
      'error': 'Access Code is invalid!'
    });
  }
});

router.put('/start-game', async (req, res, next) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  // Set joinable status to false
  mongo.updateDocument(accessCode, 'joinable', false, 'group');

  // Get members * 3 unique words
  let doc = await mongo.findDocument(accessCode, 'group');
  let numWords = doc['members'].length * NUM_CHOICES;
  let words = [...wordBank];

  // Get numWords random words from words
  let availableWords = {};
  doc['members'].forEach( (member) => {
    availableWords[member] = [];
  });

  // Get NUM_CHOICES words for each member
  for(let i = 0; i < numWords; i++){
    let rand = Math.floor(Math.random() * words.length);
    let word = words[rand];
    words.splice(rand,1);
    availableWords[doc['members'][Math.floor(i/NUM_CHOICES)]].push(word);
  }
  // Broadcast categories to channel
  pusher.triggerEvent(accessCode, 'onGameStart', availableWords);
  // Send response
  res.status(200).json({availableWords: availableWords});
});

router.put('/submit-word', async (req, res, next) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let word = req.body['word'];

  await mongo.updateDocument(accessCode, `playerToWord.${name}`, word, 'group');
  await mongo.updateDocument(accessCode, `playerChosenWord.${name}`, word, 'group');
  await mongo.updateDocument(accessCode, `wordSketches.${word}`, [], 'group');

  let doc = await mongo.findDocument(accessCode, 'group');
  res.status(200).json(doc['playerToWord']);

});

router.put('/submit-sketch', async (req, res, next) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let sketch = req.body['sketch'];

  // Get the word mapping from player
  let doc = await mongo.findDocument(accessCode, 'group');
  let word = doc['playerToWord'][name];

  // Update the document's sketches
  mongo.pushUpdate(accessCode, `wordSketches.${word}`, sketch, 'group');

  // Get number of people who submitted
  await mongo.pushUpdate(accessCode, `submittedMembers`, name, 'group');
  doc = await mongo.findDocument(accessCode, 'group');
  let submittedCount = doc['submittedMembers'].length;

  // If all sketches submitted for current round, rotate assignment, start next round and send player to word mapping
  if (submittedCount == doc['members'].length){
    // Get the round number from number of submitted sketches
    let word = Object.keys(doc['wordSketches'])[0];
    let round = doc['wordSketches'][word].length;
    rotateDict(accessCode, doc['playerChosenWord'], doc['members'], round);
  }

  res.status(200).json({
    'message': 'Success'
  })

});

router.put('/submit-guess', async (req, res, next) => {
  // Parse body
  let accessCode = req.body['accessCode'];
  let name = req.body['name'];
  let guess = req.body['guess'];

  await mongo.updateDocument(accessCode, `wordGuesses.${name}`, guess, 'group');

  res.status(200).json({
    'message': 'Success'
  })
});

// ---------------------------HELPER FUNCTIONS----------------------------------

// Mutates a dictionary by rotating it by an offset
function rotateDict(accessCode, playerChosenWord, members, offset){
  for(let i = 0; i < members.length; i++){
    // receivingMember receives currentWord
    let currentWord = playerChosenWord[members[i]];
    let receivingMember = members[(i + offset) % members.length];
    console.log(currentWord, receivingMember);
    console.log((i + offset));

    mongo.updateDocument(accessCode, `playerToWord.${receivingMember}`, currentWord, 'group');
  }
}

module.exports = router;
