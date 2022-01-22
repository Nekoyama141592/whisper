const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase)
const algoliasearch = require('algoliasearch');
const ALGOLIA_APP_ID = functions.config().algolia.app_id
// const ALGOLIA_SEARCH_API_KEY = functions.config().algolia.api_key
const ALGOLIA_ADMIN_API_KEY = functions.config().algolia.admin_api_key
// const ALGOLIA_POSTS_INDEX_NAME = "Posts";
// const ALGOLIA_USERS_INDEX_NAME = "Users"
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_API_KEY)
// firestore
var fireStore = admin.firestore()
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// exports.createPost = functions.firestore
// .document('posts/{id}')
// .onCreate(
//     async (snap,context) => {
//         const newValue = snap.data();
//         newValue.objectID = context.params.id
//         var index = client.initIndex(ALGOLIA_POSTS_INDEX_NAME);
//         index.saveObject(newValue);
//         console.log('finished')
//     }
// );

// exports.updatePost = functions.firestore
// .document('posts/{id}')
// .onUpdate(
//     async (snap, context) => {
//         const afterUpdate = snap.after.data();
//         afterUpdate.objectID = snap.after.id;
//         var index = client.initIndex(ALGOLIA_POSTS_INDEX_NAME);
//         index.saveObject(afterUpdate);
//     }
// );

// exports.deletePost = functions.firestore
// .document('posts/{id}')
// .onDelete(
//     async (snap, context) => {
//         const oldID = snap.id;
//         var index = client.initIndex(ALGOLIA_POSTS_INDEX_NAME);
//         index.deleteObject(oldID);
//     }
// );

// exports.createUser = functions.firestore
// .document('users/{id}')
// .onCreate(
//     async (snap,context) =>{
//         const newValue = snap.data();
//         newValue.objectID = context.params.id
//         var index = client.initIndex(ALGOLIA_USERS_INDEX_NAME);
//         index.saveObject(newValue);
//         console.log('finished')
//     }
// );

// exports.updateUser = functions.firestore
// .document('users/{id}')
// .onUpdate(
//     async (snap,context) => {
//         const afterUpdate = snap.after.data();
//         afterUpdate.objectID = snap.after.id;
//         var index = client.initIndex(ALGOLIA_USERS_INDEX_NAME);
//         index.saveObject(afterUpdate);
//     }
// );

// exports.deleteUser = functions.firestore
// .document('users/{id}')
// .onDelete(
//     async (snap, context) => {
//     const oldID = snap.id;
//     var index = client.initIndex(ALGOLIA_USERS_INDEX_NAME );
//     index.deleteObject(oldID);
//     }
// );

