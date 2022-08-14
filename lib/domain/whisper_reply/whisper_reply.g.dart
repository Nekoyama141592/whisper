// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WhisperReply _$$_WhisperReplyFromJson(Map<String, dynamic> json) =>
    _$_WhisperReply(
      accountName: json['accountName'] as String,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      isHidden: json['isHidden'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      likeCount: json['likeCount'] as int,
      mainWalletAddress: json['mainWalletAddress'] as String,
      muteCount: json['muteCount'] as int,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      reply: json['reply'] as String,
      replyLanguageCode: json['replyLanguageCode'] as String,
      replyNegativeScore: (json['replyNegativeScore'] as num).toDouble(),
      replyPositiveScore: (json['replyPositiveScore'] as num).toDouble(),
      replySentiment: json['replySentiment'] as String,
      postCommentId: json['postCommentId'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCreatorUid: json['postCreatorUid'] as String,
      postDocRef: json['postDocRef'],
      reportCount: json['reportCount'] as int,
      score: (json['score'] as num).toDouble(),
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userImageURL: json['userImageURL'] as String,
      userImageNegativeScore:
          (json['userImageNegativeScore'] as num).toDouble(),
      userName: json['userName'] as String,
      userNameLanguageCode: json['userNameLanguageCode'] as String,
      userNameNegativeScore: (json['userNameNegativeScore'] as num).toDouble(),
      userNamePositiveScore: (json['userNamePositiveScore'] as num).toDouble(),
      userNameSentiment: json['userNameSentiment'] as String,
    );

Map<String, dynamic> _$$_WhisperReplyToJson(_$_WhisperReply instance) =>
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
      'nftIconInfo': instance.nftIconInfo,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'reply': instance.reply,
      'replyLanguageCode': instance.replyLanguageCode,
      'replyNegativeScore': instance.replyNegativeScore,
      'replyPositiveScore': instance.replyPositiveScore,
      'replySentiment': instance.replySentiment,
      'postCommentId': instance.postCommentId,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCreatorUid': instance.postCreatorUid,
      'postDocRef': instance.postDocRef,
      'reportCount': instance.reportCount,
      'score': instance.score,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userImageNegativeScore': instance.userImageNegativeScore,
      'userName': instance.userName,
      'userNameLanguageCode': instance.userNameLanguageCode,
      'userNameNegativeScore': instance.userNameNegativeScore,
      'userNamePositiveScore': instance.userNamePositiveScore,
      'userNameSentiment': instance.userNameSentiment,
    };
