const admin = require('firebase-admin');
const functions = require("firebase-functions");
admin.initializeApp(functions.config().firebase)
const AWS = require('aws-sdk');
const sgMail = require('@sendgrid/mail');
const plusOne = 1;
const minusOne = -1;
const likeScore = 100.0;
const unlikeScore = -100.0;
const bookmarkScore = 150.0;
const unbookmarkScore = -150.0;
const limit = 500;

const AWS_ACCESS_KEY_ID = functions.config().aws.access_key_id;
const AWS_SECRET_ACCESS_KEY = functions.config().aws.secret_access_key;
const AWS_REGION = functions.config().aws.region;
// IAM設定
AWS.config.update({
    accessKeyId: AWS_ACCESS_KEY_ID,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
    region: AWS_REGION
});
// Comprehendに渡す値を準備
const comprehend = new AWS.Comprehend({apiVersion: '2017-11-27'});
// sendgrid
const SENDGRID_API_KEY = functions.config().sendgrid.api_key;
// firestore
const fireStore = admin.firestore();

function sendMail(text,subject) {
    sgMail.setApiKey(SENDGRID_API_KEY);
    const msg = {
        to: 'whisper.content.reports@gmail.com',
        from: 'whisperdialogue@gmail.com',
        subject: subject,
        text: text,
    };
    sgMail.send(msg).then(res => {
        console.log(res);
    }).catch(e => {
        console.log(e);
    });
}
function sendReport(data,subject) {
    const stringData = JSON.stringify(data);
    const result = stringData.replace(/,/g, ',\n');
    sendMail(result,subject);
}

function mul100AndRoundingDown(num) {
    const mul100 = num * 100;
    const result = Math.floor(mul100);
    return result;
}

exports.onUserMuteCreate = functions.firestore.document('userMeta/{uid}/userMutes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.mutedUid).update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }  
);
exports.onUserMuteDelete = functions.firestore.document('userMeta/{uid}/userMutes/{activeUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await fireStore.collection('users').doc(oldValue.mutedUid).update({
            'muteCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }  
);
// OK
exports.onFollowerCreate = functions.firestore.document('users/{uid}/followers/{followerUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.followedUid).update({
            'followerCount': admin.firestore.FieldValue.increment(plusOne),
        });
        await fireStore.collection('users').doc(newValue.followerUid).update({
            'followingCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onFollowerDelete = functions.firestore.document('users/{uid}/followers/{followerUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await fireStore.collection('users').doc(oldValue.followedUid).update({
            'followerCount': admin.firestore.FieldValue.increment(minusOne),
        });
        await fireStore.collection('users').doc(oldValue.followerUid).update({
            'followingCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
// OK
exports.onPostLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postLikes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(likeScore),
        });
    }
);
// OK
exports.onPostLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postLikes/{activeUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await oldValue.postDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unlikeScore),
        });
    }
);
exports.onPostReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postReports/{reportId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue,'投稿の報告' );
    }
);
exports.onPostMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postMutes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postDocRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onPostBookmarkCreate = functions.firestore.document('users/{uid}/posts/{postId}/postBookmarks/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postDocRef.update({
            'bookmarkCount': admin.firestore.FieldValue.increment(plusOne),
            'score': admin.firestore.FieldValue.increment(bookmarkScore),
        });
    }
);
// OK
exports.onPostBookmarkDelete = functions.firestore.document('users/{uid}/posts/{postId}/postBookmarks/{activeUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await oldValue.postDocRef.update({
            'bookmarkCount': admin.firestore.FieldValue.increment(minusOne),
            'score': admin.firestore.FieldValue.increment(unbookmarkScore),
        });
    }
);
// OK
exports.onPostCommentLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentLikes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onPostCommentLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentLikes/{activeUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await oldValue.postCommentDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
exports.onPostCommentReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReports/{reportId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue,'コメントの報告');
    }
);
exports.onPostCommentMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentMutes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentDocRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onPostCommentReplyLikeCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyLikes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentReplyDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onPostCommentReplyLikeDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyLikes/{activeUid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await oldValue.postCommentReplyDocRef.update({
            'likeCount': admin.firestore.FieldValue.increment(minusOne),
        });
    }
);
exports.onPostCommentReplyReportCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyReports/{reportId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentReplyDocRef.update({
            'reportCount': admin.firestore.FieldValue.increment(plusOne),
        });
        sendReport(newValue,'リプライの報告');
    }
);
exports.onPostCommentReplyMuteCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}/postCommentReplyMutes/{activeUid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postCommentReplyDocRef.update({
            'muteCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);
// OK
exports.onPostCommentCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.passiveUid).collection('posts').doc(newValue.postId).update({
            'postCommentCount': admin.firestore.FieldValue.increment(plusOne),
        });
        // sentiment
        const text = newValue.comment;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            await snap.ref.update({
                                'commentLanguageCode': lCode,
                                'commentNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                'commentPositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                'commentSentiment': dSdata.Sentiment,
                            });
                        }
                    });
                }
            }
        });
    }
);
// OK
exports.onPostCommentDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await fireStore.collection('users').doc(oldValue.passiveUid).collection('posts').doc(oldValue.postId).update({
            'postCommentCount': admin.firestore.FieldValue.increment(minusOne),
        });
        await fireStore.collection('deleteUsers').doc(oldValue.uid).collection('deletePostComments').doc(oldValue.postCommentId).set(oldValue);
    }
);
// OK
exports.onPostCommentReplyCreate = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await newValue.postDocRef.collection('postComments').doc(newValue.postCommentId).update({
            'postCommentReplyCount': admin.firestore.FieldValue.increment(plusOne),
        });
        // sentiment
        const text = newValue.reply;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            await snap.ref.update({
                                'replyLanguageCode': lCode,
                                'replyNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                'replyPositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                'replySentiment': dSdata.Sentiment,
                            });
                        }
                    });
                }
            }
        });
        
    }
);
// OK
exports.onPostCommentReplyDelete = functions.firestore.document('users/{uid}/posts/{postId}/postComments/{postCommentId}/postCommentReplies/{postCommentReplyId}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await oldValue.postDocRef.collection('postComments').doc(oldValue.postCommentId).update({
            'postCommentReplyCount': admin.firestore.FieldValue.increment(minusOne),
        });
        await fireStore.collection('deleteUsers').doc(oldValue.uid).collection('deletePostCommentReplies').doc(oldValue.postCommentReplyId).set(oldValue);
    }
);

exports.onOfficialAdvertisementImpressiCreate = functions.firestore.document('officialAdvertisements/{officialAdvertisementId}/officialAdvertisementImpressions/{officialAdvertisementImpressionId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('officialAdvertisements').doc(newValue.officialAdvertisementId).update({
            'impressionCount': admin.firestore.FieldValue.increment(plusOne),
        });
    }
);

exports.onUserUpdateLogNoBatchCreate = functions.firestore.document('users/{uid}/userUpdateLogNoBatches/{userUpdateLogNoBatchId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('users').doc(newValue.uid).update(newValue);
    }
);
exports.onUserMetaUpdateLogCreate = functions.firestore.document('userMeta/{uid}/userMetaUpdateLogs/{userMetaUpdateLogId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        await fireStore.collection('userMeta').doc(newValue.uid).update(newValue);
    }
);
exports.onPostUpdateLogCreate = functions.firestore.document('users/{uid}/posts/{postId}/postUpdateLogs/{postUpdateLogId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        const ref = fireStore.collection('users').doc(newValue.uid).posts(newValue.postId);
        await ref.update(newValue);
        // sentiment
        const text = newValue.title;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            await ref.update({
                                'titleLanguageCode': lCode,
                                'titleNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                'titlePositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                'titleSentiment': dSdata.Sentiment,
                            });
                        }
                    });
                }
            }
        });
    }
);
exports.onPostCreate = functions.firestore.document('users/{uid}/posts/{postId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        // createTimeline
        const timeline = {
            'createdAt': newValue.createdAt,
            'isRead': false,
            'postCreatorUid': newValue.uid,
            'postId': newValue.postId,
        };
        await fireStore.collection('userMeta').doc(newValue.uid).collection('timelines').doc(newValue.postId).set(timeline);
        await fireStore.collection('users').doc(newValue.uid).update({
            'postCount': admin.firestore.FieldValue.increment(plusOne),
        });
        const followers = await fireStore.collection('users').doc(newValue.uid).collection('followers').get();
        let count = 0;
        let batch = fireStore.batch();
        for (const follower of followers.docs) {
            const data = follower.data();
            const ref = fireStore.collection('userMeta').doc(data.followerUid).collection('timelines').doc(newValue.postId);
            batch.set( ref,timeline );
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
        // sentiment
        const text = newValue.title;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            await snap.ref.update({
                                'titleLanguageCode': lCode,
                                'titleNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                'titlePositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                'titleSentiment': dSdata.Sentiment,
                            });
                        }
                    });
                }
            }
        });
        
    }
);
exports.onPostDelete = functions.firestore.document('users/{uid}/posts/{postId}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        await fireStore.collection('users').doc(oldValue.uid).update({
            'postCount': admin.firestore.FieldValue.increment(minusOne),
        });
        await fireStore.collection('deleteUsers').doc(oldValue.uid).collection('deletePosts').doc(oldValue.postId).set(oldValue);
    }
);

exports.onUserUpdateLogCreate = functions.firestore.document('users/{uid}/userUpdateLogs/{userUpdateLogId}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        const ref = fireStore.collection('users').doc(newValue.uid);
        // update user
        await ref.update(newValue);
        // sentiment
        const text = newValue.title;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            const userNameNegativeScore = mul100AndRoundingDown(dSdata.SentimentScore.Negative);
                            const userNamePositiveScore = mul100AndRoundingDown(dSdata.SentimentScore.Positive);
                            const userNameSentiment = dSdata.Sentiment;
                            await ref.update({
                                'userNameLanguageCode': lCode,
                                'userNameNegativeScore': userNameNegativeScore,
                                'userNamePositiveScore': userNamePositiveScore,
                                'userNameSentiment': userNameSentiment,
                            });
                            // update posts
                            const posts = await fireStore.collection('users').doc(newValue.uid).collection('posts').get();
                            let postCount = 0;
                            let postBatch = fireStore.batch();
                            for (const post of posts.docs) {
                                postBatch.update(post.ref,{
                                    'accountName': newValue.accountName,
                                    'mainWalletAddress': newValue.mainWalletAddress,
                                    'recommendState': newValue.recommendState,
                                    'updatedAt': newValue.updatedAt,
                                    'userName': newValue.userName,
                                    'userNameLanguageCode': lCode,
                                    'userNameNegativeScore': userNameNegativeScore,
                                    'userNamePositiveScore': userNamePositiveScore,
                                    'userNameSentiment': userNameSentiment,
                                    'userImageURL': newValue.userImageURL,
                                });
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
                            // update postComments
                            const postComments = await fireStore.collectionGroup('postComments').where('uid','==',newValue.uid).get();
                            let postCommentCount = 0;
                            let postCommentBatch = fireStore.batch();
                            for (const comment of postComments.docs) {
                                postCommentBatch.update(comment.ref,{
                                    'accountName': newValue.accountName,
                                    'mainWalletAddress': newValue.mainWalletAddress,
                                    'updatedAt': newValue.updatedAt,
                                    'userName': newValue.userName,
                                    'userNameLanguageCode': lCode,
                                    'userNameNegativeScore': userNameNegativeScore,
                                    'userNamePositiveScore': userNamePositiveScore,
                                    'userNameSentiment': userNameSentiment,
                                    'userImageURL': newValue.userImageURL,
                                });
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
                            // update replies
                            const replies = await fireStore.collectionGroup('postCommentReplies').where('uid','==',newValue.uid).get();
                            let replyCount = 0;
                            let replyBatch = fireStore.batch();
                            for (const reply of replies.docs) {
                                replyBatch.update(reply.ref,{
                                    'accountName': newValue.accountName,
                                    'mainWalletAddress': newValue.mainWalletAddress,
                                    'updatedAt': newValue.updatedAt,
                                    'userName': newValue.userName,
                                    'userNameLanguageCode': lCode,
                                    'userNameNegativeScore': userNameNegativeScore,
                                    'userNamePositiveScore': userNamePositiveScore,
                                    'userNameSentiment': userNameSentiment,
                                    'userImageURL': newValue.userImageURL,
                                });
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
                            // update notifications 
                            const notifications = await fireStore.collectionGroup('notifications').where('activeUid','==',newValue.uid).get();
                            let notificationCount = 0;
                            let notificationBatch = fireStore.batch();
                            for (const notification of notifications.docs) {
                                notificationBatch.update(notification.ref,{
                                    'accountName': newValue.accountName,
                                    'mainWalletAddress': newValue.mainWalletAddress,
                                    'updatedAt': newValue.updatedAt,
                                    'userName': newValue.userName,
                                    'userNameLanguageCode': lCode,
                                    'userNameNegativeScore': userNameNegativeScore,
                                    'userNamePositiveScore': userNamePositiveScore,
                                    'userNameSentiment': userNameSentiment,
                                    'userImageURL': newValue.userImageURL,
                                });
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
                        }
                    });
                }
            }
        });
    }
);
exports.onUserCreate = functions.firestore.document('users/{uid}').onCreate(
    async (snap,_) => {
        const newValue = snap.data();
        // sentiment
        const text = newValue.userName;
        const dDparams = {
            Text: text  // 解析したい文字列
        };
        let lCode = '';
        comprehend.detectDominantLanguage(dDparams, async (dDerr, dDdata) => {
            if ( dDerr ) {
            console.error(dDerr, dDerr.stack)
            } else {
                lCode = dDdata.Languages[0]['LanguageCode'];
                if (lCode) {
                    const dSparams = {
                        LanguageCode: lCode,
                        Text: text,
                    }
                    comprehend.detectSentiment(dSparams, async (dSerr, dSdata) => {
                        if ( dSerr ) {
                            console.error(dSerr, dSerr.stack)
                        } else {
                            await snap.ref.update({
                                'userNameLanguageCode': lCode,
                                'userNameNegativeScore': mul100AndRoundingDown(dSdata.SentimentScore.Negative),
                                'userNamePositiveScore': mul100AndRoundingDown(dSdata.SentimentScore.Positive),
                                'userNameSentiment': dSdata.Sentiment,
                            });
                        }
                    });
                }
            }
        });
    }
);
exports.onUserMetaDelete = functions.firestore.document('userMeta/{uid}').onDelete(
    async (snap,_) => {
        const oldValue = snap.data();
        // delete postCommentReplyLikes
        const postCommentReplyLikes = await fireStore.collectionGroup('postCommentReplyLikes').where('activeUid','==',oldValue.uid).get();
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
        // delete my follows
        const myFollows = await fireStore.collectionGroup('followers').where('followerUid','==',oldValue.uid).get();
        let myFollowCount = 0;
        let myFollowBatch = fireStore.batch();
        for (const myFollow of myFollows.docs) {
            myFollowBatch.delete(myFollow.ref);
            myFollowCount += 1;
            if (myFollowCount == limit) {
                await myFollowBatch.commit();
                myFollowBatch = fireStore.batch();
                myFollowCount = 0;
            }
        }
        if (myFollowCount > 0) {
            await myFollowBatch.commit();
        }
        
        // delete replies
        const replies = await fireStore.collectionGroup('postCommentReplies').where('uid','==',oldValue.uid).get();
        let replyCount = 0;
        let replyBatch = fireStore.batch();
        let createDeletePostCommentReplyBatch = fireStore.batch();
        for (const reply of replies.docs) {
            replyBatch.delete(reply.ref);
            const data = reply.data();
            const deletePostCommentReplyRef = fireStore.collection('deleteUsers').doc(data.uid).collection('deletePostCommentReplies').doc(data.postCommentReplyId);
            createDeletePostCommentReplyBatch.set(deletePostCommentReplyRef,data);
            replyCount += 1;
            if (replyCount == limit) {
                await replyBatch.commit();
                await createDeletePostCommentReplyBatch.commit();
                replyBatch = fireStore.batch();
                createDeletePostCommentReplyBatch = fireStore.batch();
                replyCount = 0;
            }
        }
        if (replyCount > 0) {
            await replyBatch.commit();
            await createDeletePostCommentReplyBatch.commit();
        }
        // deletePostCommentLikes
        const postCommentLikes = await fireStore.collectionGroup('postCommentLikes').where('activeUid','==',oldValue.uid).get();
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
        // delete tokens
        const tokens = await fireStore.collection('userMeta').doc(oldValue.uid).collection('tokens').get();
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
        // delete comments
        const postComments = await fireStore.collectionGroup('postComments').where('uid','==',oldValue.uid).get();
        let postCommentCount = 0;
        let postCommentBatch = fireStore.batch();
        let createDeletePostCommentBatch = fireStore.batch();
        for (const comment of postComments.docs) {
            postCommentBatch.delete(comment.ref);
            const data = comment.data();
            const deletePostCommentRef = fireStore.collection('deleteUsers').doc(data.uid).collection('deletePostComments').doc(data.postCommentId);
            createDeletePostCommentBatch.set(deletePostCommentRef,data);
            postCommentCount += 1;
            if (postCommentCount == limit) {
                await postCommentBatch.commit();
                await createDeletePostCommentBatch.commit();
                postCommentBatch = fireStore.batch();
                createDeletePostCommentBatch = fireStore.batch();
                postCommentCount = 0;
            }
        }
        if (postCommentCount > 0) {
            await postCommentBatch.commit();
            await createDeletePostCommentBatch.commit();
        }
        // delete postLikes
        const postLikes = await fireStore.collectionGroup('postLikes').where('activeUid','==',oldValue.uid).get();
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
        const postBookmarks = await fireStore.collectionGroup('postBookmarks').where('activeUid','==',oldValue.uid).get();
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
        // delete notifications
        const notifications = await fireStore.collectionGroup('notifications').where('activeUid','==',oldValue.uid).get();
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
        // delete myNotifications
        const myNotifications = await fireStore.collection('userMeta').doc(oldValue.uid).collection('notifications').get();
        let myNotificationCount = 0;
        let myNotificationBatch = fireStore.batch();
        for (const myNotification of myNotifications.docs) {
            myNotificationBatch.delete(myNotification.ref);
            myNotificationCount += 1;
            if (myNotificationCount == limit) {
                await myNotificationBatch.commit();
                myNotificationBatch = fireStore.batch();
                myNotificationCount = 0;
            }
        }
        if (myNotificationCount > 0) {
            await myNotificationBatch.commit();
        }
        // delete posts
        const posts = await fireStore.collection('users').doc(oldValue.uid).collection('posts').get();
        let postCount = 0;
        let postBatch = fireStore.batch();
        let createDeletePostBatch = fireStore.batch();
        for (const post of posts.docs) {
            postBatch.delete(post.ref);
            const data = post.data();
            const deletePostRef = fireStore.collection('deleteUsers').doc(data.uid).collection('deletePosts').doc(data.postId);
            createDeletePostBatch.set(deletePostRef,data);
            postCount += 1;
            if (postCount == limit) {
                await postBatch.commit();
                await createDeletePostBatch.commit();
                postBatch = fireStore.batch();
                createDeletePostBatch = fireStore.batch();
                postCount = 0;
            }
        }
        if (postCount > 0) {
            await postBatch.commit();
            await createDeletePostBatch.commit();
        }
        // delete timeline
        const timelines = await fireStore.collectionGroup('timelines').where('postCreatorUid','==',oldValue.uid).get();
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
         // delete myTimeline
         const myTimelines = await fireStore.collection('userMeta').doc(oldValue.uid).collection('timelines').get();
         let myTimelineCount = 0;
         let myTimelineBatch = fireStore.batch();
         for (const myTimeline of myTimelines.docs) {
             myTimelineBatch.delete(myTimeline.ref);
             myTimelineCount += 1;
             if (myTimelineCount == limit) {
                 await myTimelineBatch.commit();
                 myTimelineBatch = fireStore.batch();
                 myTimelineCount = 0;
             }
         }
         if (myTimelineCount > 0) {
             await myTimelineBatch.commit();
         }
        // delete user
        const user = await fireStore.collection('users').doc(oldValue.uid).get();
        await user.ref.delete();
        // create deleteUser
        const data = user.data();
        await fireStore.collection('deleteUsers').doc(oldValue.uid).set(data);
        // create deleteUserMeta
        await fireStore.collection('deleteUserMeta').doc(oldValue.uid).set(oldValue);
    }
);