const admin = require('firebase-admin');
const functions = require("firebase-functions");
admin.initializeApp(functions.config().firebase)
const plusOne = 1;
const minusOne = -1;
const likeScore = 100.0;
const unlikeScore = -100.0;
const bookmarkScore = 150.0;
const unbookmarkScore = -150;
const limit = 500;
// const algoliasearch = require('algoliasearch');
// const ALGOLIA_APP_ID = functions.config().algolia.app_id
// const ALGOLIA_SEARCH_API_KEY = functions.config().algolia.api_key
// const ALGOLIA_ADMIN_API_KEY = functions.config().algolia.admin_api_key
// const ALGOLIA_POSTS_INDEX_NAME = "Posts";
// const ALGOLIA_USERS_INDEX_NAME = "Users"
// const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_API_KEY)

// firestore
const fireStore = admin.firestore();
const bucket = admin.storage().bucket();

exports.tokenCreate = functions.firestore.document('userMeta/{uid}/tokens/{tokenId}').onCreate(
    async (snap,_) => {

    }
);

exports.likePost = functions.firestore.document('users/{uid}/posts/{postId}/postLikes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        fireStore.collection('posts').doc(newValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(likeScore),
        });
    }
);
exports.unlikePost = functions.firestore.document('posts/{id}/likes/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        fireStore.collection('posts').doc(oldValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unlikeScore),
        });
    }
);
exports.bookmarkPost = functions.firestore.document('posts/{id}/bookmarks/{uid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        fireStore.collection('posts').doc(newValue.postId).update({
            'bookmarkCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(bookmarkScore),
        });
    }
);
exports.unbookmarkPost = functions.firestore.document('posts/{id}/bookmarks/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        fireStore.collection('posts').doc(oldValue.postId).update({
            'bookmarkCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unbookmarkScore),
        });
    }
);
exports.likeComment = functions.firestore.document('comments/{id}/likes/{uid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        fireStore.collection('posts').doc(newValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
exports.unlikeComment = functions.firestore.document('comments/{id}/likes/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        fireStore.collection('posts').doc(oldValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
exports.likeReply = functions.firestore.document('posts/{id}/likes/{uid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        fireStore.collection('posts').doc(newValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
exports.unlikeReply = functions.firestore.document('replys/{id}/likes/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        fireStore.collection('posts').doc(oldValue.postId).update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);

exports.followUser = functions.firestore.document('users/{uid}/followers/{followerUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        fireStore.collection('users').doc(newValue.passiveUid).update({
            'followerCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.unfollowUser = functions.firestore.document('users/{uid}/followers/{followerUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        fireStore.collection('users').doc(oldValue.passiveUid).update({
            'followerCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);

exports.deleteUser = functions.firestore.document('users/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        // delete user
        const userMeta = await fireStore.collection('userMeta').doc(oldValue.id).get();
        await userMeta.ref.delete();
        // delete posts
        const posts = await fireStore.collection('posts').where('uid','==',oldValue.id).get();
        let postCount = 0;
        let postBatch = fireStore.batch();
        for (const post of posts.docs) {
            postBatch.delete(post.ref);
            postCount += 1;
            if (postCount == limit) {
                await postBatch.commit();
                postBatch = fireStore.batch();
                postCount = 0;
            }
        }
        if (postCount > 0) {
            await postBatch.commit();
        }
        // delete comments
        const comments = await fireStore.collectionGroup('postComments').where('uid','==',oldValue.id).get();
        let commentCount = 0;
        let commentBatch = fireStore.batch();
        for (const comment of comments.docs) {
            commentBatch.delete(comment.ref);
            commentCount += 1;
            if (commentCount == limit) {
                await commentBatch.commit();
                commentBatch = fireStore.batch();
                commentCount = 0;
            }
        }
        if (replyCount > 0) {
            await replyBatch.commit();
        }
        // delete replys
        const replys = await fireStore.collectionGroup('postCommentReplys').where('uid','==',oldValue.id).get();
        let replyCount = 0;
        let replyBatch = fireStore.batch();
        for (const reply of replys.docs) {
            replyBatch.delete(reply.ref);
            replyCount += 1;
            if (replyCount == limit) {
                await replyBatch.commit();
                replyBatch = fireStore.batch();
                replyCount = 0;
            }
        }
        if (replyCount > 0) {
            await replyBatch.commit();
        }
        // delete tokens
        const tokens = await fireStore.collection('userMeta').doc(oldValue.id).collection('tokens').get();
        let tokenCount = 0;
        let tokenBatch = fireStore.batch();
        for (const token of tokens.docs) {
            tokenBatch.delete(token.ref);
            tokenCount += 1;
            if (tokenCount == limit) {
                await tokenBatch.commit();
                tokenBatch = fireStore.batch();
                tokenCount = 0;
            }
        }
        if (tokenCount > 0) {
            await tokenBatch.commit();
        }
        // delete notifications
        const notifications = await fireStore.collection('userMeta').doc(oldValue.id).collection('notifications').get();
        let notificationCount = 0;
        let notificationBatch = fireStore.batch();
        for (const notification of notifications.docs) {
            notificationBatch.delete(notification.ref);
            notificationCount += 1;
            if (notificationCount == limit) {
                await notificationBatch.commit();
                notificationBatch = fireStore.batch();
                notificationCount = 0;
            }
        }
        if (notificationCount > 0) {
            await notificationBatch.commit();
        }
        // delete post storage
        bucket.deleteFiles({
            prefix: `posts/${oldValue.id}`
        });
        // delete userImage storage
        bucket.deleteFiles({
            prefix: `userImages/${oldValue.id}`
        });
        // delete postImages storage
        bucket.deleteFiles({
            prefix: `postImages/${oldValue.id}`
        });
    }
);

exports.createTimeline = functions.firestore.document('posts/{id}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        const followers = await fireStore.collection('users').doc(newValue.uid).collection('followers').get();
        let count = 0;
        let batch = fireStore.batch();
        for (const follower of followers.docs) {
            const ref = fireStore.collection('users').doc(follower.id).collection('timelines').doc(newValue.postId);
            batch.set(ref,{
                'createdAt': admin.firestore.Timestamp.now(),
                'creatorUid': newValue.uid,
                'isRead': false,
                'postId': newValue.postId,
            });
            count += 1;
            if (count == limit) {
                await batch.commit();
                batch = fireStore.batch();
                count = 0;
            }
        }
        if (count >0) {
            await batch.commit();
        }
        
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