// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whipser_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperReply _$WhisperReplyFromJson(Map<String, dynamic> json) => WhisperReply(
      accountName: json['accountName'] as String,
      createdAt: json['createdAt'],
      postCommentId: json['postCommentId'] as String,
      followerCount: json['followerCount'] as int,
      isHidden: json['isHidden'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      likeCount: json['likeCount'] as int,
      mainWalletAddress: json['mainWalletAddress'] as String,
      muteCount: json['muteCount'] as int,
      negativeScore: json['negativeScore'] as num,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      positiveScore: json['positiveScore'] as num,
      reply: json['reply'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCreatorUid: json['postCreatorUid'] as String,
      postDocRef: json['postDocRef'],
      reportCount: json['reportCount'] as int,
      score: json['score'] as num,
      sentiment: json['sentiment'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$WhisperReplyToJson(WhisperReply instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'isHidden': instance.isHidden,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isPinned': instance.isPinned,
      'likeCount': instance.likeCount,
      'mainWalletAddress': instance.mainWalletAddress,
      'muteCount': instance.muteCount,
      'negativeScore': instance.negativeScore,
      'nftIconInfo': instance.nftIconInfo,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'positiveScore': instance.positiveScore,
      'reply': instance.reply,
      'postCommentId': instance.postCommentId,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCreatorUid': instance.postCreatorUid,
      'postDocRef': instance.postDocRef,
      'reportCount': instance.reportCount,
      'score': instance.score,
      'sentiment': instance.sentiment,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
