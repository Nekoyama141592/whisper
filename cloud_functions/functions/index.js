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

exports.onCreateToken = functions.firestore.document('userMeta/{uid}/tokens/{tokenId}').onCreate(
    async (snap,_) => {
        const token = snap.data();
        const tokenType = token.tokenType;
        if (tokenType == 'bookmarkLabel' ) {
            
        } else if (tokenType == 'bookmarkPost' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('posts').doc(token.postId).update({
                'bookmarkCount': admin.firestore.FieldValue.increment(plusOne),
                'score': admin.firestore.FieldValue.increment(bookmarkScore),
            });
        } else if (tokenType == 'following' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('followers').doc(token.myUid).set({
               'followerUid': token.myUid,
               'myUid': token.passiveUid,
               'createdAt': token.createdAt, 
            });
            await fireStore.collection('users').doc(token.passiveUid).update({
                'followerCount': admin.firestore.FieldValue.increment(plusOne),
            });
        } else if (tokenType == 'likePost' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('posts').doc(token.postId).update({
                'likeCount': admin.firestore.FieldValue.increment(plusOne),
                'score': admin.firestore.FieldValue.increment(likeScore),
            });
        } else if (tokenType == 'likeComment' ) {
            await token.postCommentDocRef.update({
                'likeCount': admin.firestore.FieldValue.increment(plusOne),
            });
        } else if (tokenType == 'likeReply' ) {
            await token.postCommentReplyDocRef.update({
                'likeCount': admin.firestore.FieldValue.increment(plusOne),
            });
        } else if (tokenType == 'searchHistory' ) {

        } else if (tokenType == 'readPost' ) {

        } else if (tokenType == 'watchlist' ) {

        } else if (tokenType == 'blockUser' ) {

        } else if (tokenType == 'muteComment' ) {

        } else if (tokenType == 'mutePost' ) {

        } else if (tokenType == 'muteReply' ) {

        } else if (tokenType == 'muteUser' ) {
            
        }
    }
);
exports.onDeleteToken = functions.firestore.document('userMeta/{uid}/tokens/{tokenId}').onDelete(
    async (snap,_) => {
        const token = snap.data();
        const tokenType = token.tokenType;
        if (tokenType == 'bookmarkLabel' ) {

        } else if (tokenType == 'bookmarkPost' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('posts').doc(token.postId).update({
                'bookmarkCount': admin.firestore.FieldValue.increment(minusOne),
                'score': admin.firestore.FieldValue.increment(unbookmarkScore),
            });
        } else if (tokenType == 'following' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('followers').doc(token.myUid).delete();
            await fireStore.collection('users').doc(token.passiveUid).update({
                'followerCount': admin.firestore.FieldValue.increment(minusOne),
            });
        } else if (tokenType == 'likePost' ) {
            await fireStore.collection('users').doc(token.passiveUid).collection('posts').doc(token.postId).update({
                'likeCount': admin.firestore.FieldValue.increment(minusOne),
                'score': admin.firestore.FieldValue.increment(unlikeScore),
            });
        } else if (tokenType == 'likeComment' ) {
            await token.postCommentDocRef.update({
                'likeCount': admin.firestore.FieldValue.increment(minusOne),
            });
        } else if (tokenType == 'likeReply' ) {
            await token.postCommentReplyDocRef.update({
                'likeCount': admin.firestore.FieldValue.increment(minusOne),
            });
        } else if (tokenType == 'searchHistory' ) {

        } else if (tokenType == 'readPost' ) {

        } else if (tokenType == 'watchlist' ) {

        } else if (tokenType == 'blockUser' ) {

        } else if (tokenType == 'muteComment' ) {

        } else if (tokenType == 'mutePost' ) {

        } else if (tokenType == 'muteReply' ) {

        } else if (tokenType == 'muteUser' ) {

        }
    }
);

exports.deleteUser = functions.firestore.document('users/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        // delete user
        const userMeta = await fireStore.collection('userMeta').doc(oldValue.id).get();
        await userMeta.ref.delete();
        // delete posts
        const posts = await fireStore.collection('users').doc(oldValue.id).collection('posts').where('uid','==',oldValue.id).get();
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
        // delete postLikes
        const postLikes = await fireStore.collectionGroup('postLikes').where('activeUid','==',oldValue.id).get();
        let postLikeCount = 0;
        let postLikeBatch = fireStore.batch();
        for (const postLike of postLikes.docs) {
            postLikeBatch.delete(postLike.ref);
            postLikeCount += 1;
            if (postLikeCount == limit) {
                await postLikeBatch.commit();
                postLikeBatch = fireStore.batch();
                postLikeCount = 0;
            }
        }
        if (postLikeCount > 0) {
            await postLikeBatch.commit();
        }
        // delete postBookmarks
        const postBookmarks = await fireStore.collectionGroup('postBookmarks').where('activeUid','==',oldValue.id).get();
        let postBookmarkCount = 0;
        let postBookmarkBatch = fireStore.batch();
        for (const postBookmark of postBookmarks.docs) {
            postBookmarkBatch.delete(postBookmark.ref);
            postBookmarkCount += 1;
            if (postBookmarkCount == limit) {
                await postBookmarkBatch.commit();
                postBookmarkBatch = fireStore.batch();
                postBookmarkCount = 0;
            }
        }
        if (postBookmarkCount > 0) {
            await postBookmarkBatch.commit();
        }
        // delete comments
        const postComments = await fireStore.collectionGroup('postComments').where('uid','==',oldValue.id).get();
        let postCommentCount = 0;
        let postCommentBatch = fireStore.batch();
        for (const comment of postComments.docs) {
            postCommentBatch.delete(comment.ref);
            postCommentCount += 1;
            if (postCommentCount == limit) {
                await postCommentBatch.commit();
                postCommentBatch = fireStore.batch();
                postCommentCount = 0;
            }
        }
        if (postCommentCount > 0) {
            await postCommentBatch.commit();
        }
        // deletePostCommentLikes
        const postCommentLikes = await fireStore.collectionGroup('postCommentLikes').where('activeUid','==',oldValue.id).get();
        let postCommentLikeCount = 0;
        let postCommentLikeBatch = fireStore.batch();
        for (const postCommentLike of postCommentLikes.docs) {
            postCommentLikeBatch.delete(postCommentLike.ref);
            postCommentLikeCount += 1;
            if (postCommentLikeCount == limit) {
                await postCommentLikeBatch.commit();
                postCommentLikeBatch = fireStore.batch();
                postCommentLikeCount = 0;
            }
        }
        if (postCommentLikeCount > 0) {
            await postCommentLikeBatch.commit();
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
        // delete postCommentReplyLikes
        const postCommentReplyLikes = await fireStore.collectionGroup('postCommentReplyLikes').where('uid','==',oldValue.id).get();
        let postCommentReplyLikeCount = 0;
        let postCommentReplyLikeBatch = fireStore.batch();
        for (const postCommentReplyLike of postCommentReplyLikes.docs) {
            postCommentReplyLikeBatch.delete(postCommentReplyLike.ref);
            postCommentReplyLikeCount += 1;
            if (postCommentReplyLikeCount == limit) {
                await postCommentReplyLikeBatch.commit();
                postCommentReplyLikeBatch = fireStore.batch();
                postCommentReplyLikeCount = 0;
            }
        }
        if (postCommentReplyLikeCount > 0) {
            await postCommentReplyLikeBatch.commit();
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
        // delete timeline
        const timelines = await fireStore.collection('userMeta').doc(oldValue.id).collection('timelines').get();
        let timelineCount = 0;
        let timelineBatch = fireStore.batch();
        for (const timeline of timelines.docs) {
            timelineBatch.delete(timeline.ref);
            timelineCount += 1;
            if (timelineCount == limit) {
                await timelineBatch.commit();
                timelineBatch = fireStore.batch();
                timelineCount = 0;
            }
        }
        if (timelineCount > 0) {
            await timelineBatch.commit();
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

exports.createTimeline = functions.firestore.document('users/{uid}/posts/{id}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        const timeline = {
            'createdAt': admin.firestore.Timestamp.now(),
            'creatorUid': newValue.uid,
            'isRead': false,
            'isDelete': false,
            'postId': newValue.postId,  
        };
        await fireStore.collection('userMeta').doc(newValue.uid).collection('timelines').doc(newValue.postId).set(timeline);
        const followers = await fireStore.collection('users').doc(newValue.uid).collection('followers').get();
        let count = 0;
        let batch = fireStore.batch();
        for (const follower of followers.docs) {
            const ref = fireStore.collection('userMeta').doc(follower.id).collection('timelines').doc(newValue.postId);
            batch.set(ref,timeline );
            count += 1;
            if (count == limit) {
                await batch.commit();
                batch = fireStore.batch();
                count = 0;
            }
        }
        if (count > 0) {
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