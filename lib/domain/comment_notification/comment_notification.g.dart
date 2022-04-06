// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentNotification _$CommentNotificationFromJson(Map<String, dynamic> json) =>
    CommentNotification(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      commentLanguageCode: json['commentLanguageCode'] as String,
      commentNegativeScore: json['commentNegativeScore'] as num,
      commentPositiveScore: json['commentPositiveScore'] as num,
      commentSentiment: json['commentSentiment'] as String,
      postCommentId: json['postCommentId'] as String,
      commentScore: json['commentScore'] as num,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isRead: json['isRead'] as bool,
      mainWalletAddress: json['mainWalletAddress'] as String,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      notificationId: json['notificationId'] as String,
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      postCommentDocRef: json['postCommentDocRef'],
      postDocRef: json['postDocRef'],
      postTitle: json['postTitle'] as String,
      notificationType: json['notificationType'] as String,
      activeUid: json['activeUid'] as String,
      updatedAt: json['updatedAt'],
      userImageURL: json['userImageURL'] as String,
      userImageNegativeScore: json['userImageNegativeScore'] as num,
      userName: json['userName'] as String,
      userNameLanguageCode: json['userNameLanguageCode'] as String,
      userNameNegativeScore: json['userNameNegativeScore'] as num,
      userNamePositiveScore: json['userNamePositiveScore'] as num,
      userNameSentiment: json['userNameSentiment'] as String,
    );

Map<String, dynamic> _$CommentNotificationToJson(
        CommentNotification instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'activeUid': instance.activeUid,
      'comment': instance.comment,
      'commentLanguageCode': instance.commentLanguageCode,
      'commentPositiveScore': instance.commentPositiveScore,
      'commentNegativeScore': instance.commentNegativeScore,
      'commentSentiment': instance.commentSentiment,
      'postCommentId': instance.postCommentId,
      'commentScore': instance.commentScore,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isRead': instance.isRead,
      'mainWalletAddress': instance.mainWalletAddress,
      'nftIconInfo': instance.nftIconInfo,
      'notificationId': instance.notificationId,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'postCommentDocRef': instance.postCommentDocRef,
      'postDocRef': instance.postDocRef,
      'postTitle': instance.postTitle,
      'notificationType': instance.notificationType,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userImageNegativeScore': instance.userImageNegativeScore,
      'userName': instance.userName,
      'userNameLanguageCode': instance.userNameLanguageCode,
      'userNameNegativeScore': instance.userNameNegativeScore,
      'userNamePositiveScore': instance.userNamePositiveScore,
      'userNameSentiment': instance.userNameSentiment,
    };
