// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_post_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Timeline _$$_TimelineFromJson(Map<String, dynamic> json) => _$_Timeline(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      commentLanguageCode: json['commentLanguageCode'] as String,
      commentPositiveScore: (json['commentPositiveScore'] as num).toDouble(),
      commentNegativeScore: (json['commentNegativeScore'] as num).toDouble(),
      commentSentiment: json['commentSentiment'] as String,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      isHidden: json['isHidden'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      likeCount: json['likeCount'] as int,
      masterReplied: json['masterReplied'] as bool,
      mainWalletAddress: json['mainWalletAddress'] as String,
      muteCount: json['muteCount'] as int,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      passiveUid: json['passiveUid'] as String,
      postCommentId: json['postCommentId'] as String,
      postId: json['postId'] as String,
      postCommentReplyCount: json['postCommentReplyCount'] as int,
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

Map<String, dynamic> _$$_TimelineToJson(_$_Timeline instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'comment': instance.comment,
      'commentLanguageCode': instance.commentLanguageCode,
      'commentPositiveScore': instance.commentPositiveScore,
      'commentNegativeScore': instance.commentNegativeScore,
      'commentSentiment': instance.commentSentiment,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'isHidden': instance.isHidden,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isPinned': instance.isPinned,
      'likeCount': instance.likeCount,
      'masterReplied': instance.masterReplied,
      'mainWalletAddress': instance.mainWalletAddress,
      'muteCount': instance.muteCount,
      'nftIconInfo': instance.nftIconInfo,
      'passiveUid': instance.passiveUid,
      'postCommentId': instance.postCommentId,
      'postId': instance.postId,
      'postCommentReplyCount': instance.postCommentReplyCount,
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
