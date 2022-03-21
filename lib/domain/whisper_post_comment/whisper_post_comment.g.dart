// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_post_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperPostComment _$WhisperPostCommentFromJson(Map<String, dynamic> json) =>
    WhisperPostComment(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      postCommentId: json['postCommentId'] as String,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      isDelete: json['isDelete'] as bool,
      isHidden: json['isHidden'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      likeCount: json['likeCount'] as int,
      masterReplied: json['masterReplied'] as bool,
      mainWalletAddress: json['mainWalletAddress'] as String,
      negativeScore: json['negativeScore'] as num,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      passiveUid: json['passiveUid'] as String,
      positiveScore: json['positiveScore'] as num,
      postId: json['postId'] as String,
      postCommentReplyCount: json['postCommentReplyCount'] as int,
      score: json['score'] as num,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$WhisperPostCommentToJson(WhisperPostComment instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'isDelete': instance.isDelete,
      'isHidden': instance.isHidden,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'likeCount': instance.likeCount,
      'masterReplied': instance.masterReplied,
      'mainWalletAddress': instance.mainWalletAddress,
      'negativeScore': instance.negativeScore,
      'nftIconInfo': instance.nftIconInfo,
      'passiveUid': instance.passiveUid,
      'positiveScore': instance.positiveScore,
      'postCommentId': instance.postCommentId,
      'postId': instance.postId,
      'postCommentReplyCount': instance.postCommentReplyCount,
      'score': instance.score,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
