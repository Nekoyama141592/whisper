const admin = require('firebase-admin');
const functions = require("firebase-functions");
admin.initializeApp(functions.config().firebase)
const plusOne = 1;
const minusOne = -1;
const likeScore = 100.0;
const unlikeScore = -100.0;
const bookmarkScore = 150.0;
const unbookmarkScore = -150;
// const algoliasearch = require('algoliasearch');
// const ALGOLIA_APP_ID = functions.config().algolia.app_id
// const ALGOLIA_SEARCH_API_KEY = functions.config().algolia.api_key
// const ALGOLIA_ADMIN_API_KEY = functions.config().algolia.admin_api_key
// const ALGOLIA_POSTS_INDEX_NAME = "Posts";
// const ALGOLIA_USERS_INDEX_NAME = "Users"
// const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_API_KEY)
// firestore
var fireStore = admin.firestore()

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.likePost = functions.firestore.document('posts/{id}/likes/{uid}').onCreate(
    async (_,__) => {
        fireStore.collection('posts').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(likeScore),
        });
    }
);
exports.unlikePost = functions.firestore.document('posts/{id}/likes/{uid}').onDelete(
    async (_,__) => {
        fireStore.collection('posts').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unlikeScore),
        });
    }
);
exports.bookmarkPost = functions.firestore.document('posts/{id}/bookmarks/{uid}').onCreate(
    async (_,__) => {
        fireStore.collection('posts').doc(id).update({
            'bookmarkCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(bookmarkScore),
        });
    }
);
exports.unbookmarkPost = functions.firestore.document('posts/{id}/bookmarks/{uid}').onDelete(
    async (_,__) => {
        fireStore.collection('posts').doc(id).update({
            'bookmarkCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unbookmarkScore),
        });
    }
);
exports.likeComment = functions.firestore.document('comments/{id}/likes/{uid}').onCreate(
    async (_,__) => {
        fireStore.collection('comments').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
exports.unlikeComment = functions.firestore.document('comments/{id}/likes/{uid}').onDelete(
    async (_,__) => {
        fireStore.collection('comments').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
exports.likeReply = functions.firestore.document('posts/{id}/likes/{uid}').onCreate(
    async (_,__) => {
        fireStore.collection('replys').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
exports.unlikeReply = functions.firestore.document('replys/{id}/likes/{uid}').onDelete(
    async (_,__) => {
        fireStore.collection('replys').doc(id).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);

exports.followUser = functions.firestore.document('users/{uid}/followers/{followerUid}').onCreate(
    async (_,__) => {
        fireStore.collection('users').doc(uid).update({
            'followerCount': FieldValue.increment(plusOne),
        });
    }
);

exports.unfollowUser = functions.firestore.document('users/{uid}/followers/{followerUid}').onDelete(
    async (_,__) => {
        fireStore.collection('users').doc(uid).update({
            'followerCount': FieldValue.increment(minusOne),
        });
    }
);
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