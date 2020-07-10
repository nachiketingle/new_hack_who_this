var Pusher = require('pusher');

let pusher = new Pusher({
  appId: process.env.PUSHER_APP_ID,
  key: process.env.PUSHER_KEY,
  secret: process.env.PUSHER_SECRET,
  cluster: 'us3',
  encrypted: true
});

module.exports = {
  triggerEvent: (accessCode, event, message) => {
    console.log(`Triggering Channel ${accessCode} Event ${event} Message ${message}`);
    pusher.trigger(accessCode, event, {
      'event': event,
      'message': message
    });
  }
}
