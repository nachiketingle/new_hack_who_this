var express = require('express');
const fetch = require('node-fetch');
const mongo = require('../lib/mongo');
const pusher = require('../lib/pusher');
const {
  v4: uuidv4
} = require('uuid');

var router = express.Router();
const ACCESS_LENGTH_CODE = 4;

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});


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
    'members': [name],
  };

  // keep generating accessCodes until a valid one is generated
  // while (true) {
  //   // finds a doc with access code
  //   let doc = await mongo.findDocument(accessCode, 'group');
  //   // if doc does not exist
  //   if (doc == null) {
  //     // create the doc
  //     mongo.addDocument(group, 'group');
  //     break;
  //   }
  //   // retry access code
  //   accessCode = (uuidv4().split('-'))[0].substring(0, ACCESS_LENGTH_CODE);
  //   group['accessCode'] = accessCode;
  // }
  // respond with the access code
  res.status(201).json({
    accessCode: accessCode
  });
});

router.put('/join-group', (req, res, next) => {
  res.status(200).json({
    'message': 'Success',
    'groupName': 'Jennie Kim Crew',
    'members': ['Baron, Bacho, Bevin']
  })
});

router.put('/start-game', (req, res, next) => {
  res.status(200).json({
    'availableWords': {
      'Baron': ['Apples', 'Banana', 'Crap'],
      'Bacho' : ['Dog', 'Elephant', 'Farm'],
      'Bevin' : ['GDragon', 'Hwasa', 'Itzy']
    }
  })
});

router.put('/submit-word', (req, res, next) => {
  res.status(200).json({
    'selectedWords': {
      'Baron': 'Apples',
      'Bacho' : 'Dog',
      'Bevin' : 'GDragon'
    }
  })
});

router.put('/submit-sketch', (req, res, next) => {
  res.status(200).json({
    'message': 'Success'
  })
});

router.put('/submit-guess', (req, res, next) => {
  res.status(200).json({
    'message': 'Success'
  })
});

module.exports = router;
