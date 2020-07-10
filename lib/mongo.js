const { MongoClient } = require('mongodb');
const url = process.env.MONGO_URL;
const client = new MongoClient(url);
const dbName = 'Telepic';

client.connect();

module.exports = {
  viewDB: async function (collection, cb) {
    try {
      const db = client.db(dbName);
      const col = db.collection(collection);
      col.find({}).toArray(function (err, docs) {
        console.log(docs)
        cb(docs);
    })
    } catch (err) {
      console.log(err.stack);
    }
  },
  clearCollection: async function (collection, cb) {
    try {
      const db = client.db(dbName);
      const col = db.collection(collection);
      col.remove({})
    } catch (err) {
      console.log(err.stack);
    }
  },
  addDocument: async function (group, collection) {
    try {
      const db = client.db(dbName);

      const col = db.collection(collection);

      // Insert a single document, wait for promise so we can read it back
      const p = await col.insertOne(group);

    } catch (err) {
      console.log(err.stack);
    }
  },
  findDocument: async function (name, collection) {
    try {
      const db = client.db(dbName);
      console.log(name);
      // Use the collection "people"
      const col = db.collection(collection);
      return col.findOne({ 'accessCode': name });

    } catch (err) {
      console.log(err.stack);
    }
  },
  updateDocument: async function (accessCode, key, value, collection) {
    try {
      const db = client.db(dbName);
      // Use the collection "people"
      const col = db.collection(collection);
      let newDict = {};
      newDict[key] = value;
      return col.updateOne({ 'accessCode': accessCode }, { $set: newDict });
    } catch (err) {
      console.log(err.stack);
    }
  },
  deleteDocument: async function (name, collection) {
    try {
      const db = client.db(dbName);
      const col = db.collection(collection);
      return col.deleteOne({ 'accessCode': name });

    } catch (err) {
      console.log(err.stack);
    }
  }
}
