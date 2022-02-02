// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentNotification _$CommentNotificationFromJson(Map<String, dynamic> json) =>
    CommentNotification(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      postCommentId: json['postCommentId'] as String,
      commentScore: json['commentScore'] as num,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isRead: json['isRead'] as bool,
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
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$CommentNotificationToJson(
        CommentNotification instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'activeUid': instance.activeUid,
      'comment': instance.comment,
      'postCommentId': instance.postCommentId,
      'commentScore': instance.commentScore,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isRead': instance.isRead,
      'notificationId': instance.notificationId,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'postCommentDocRef': instance.postCommentDocRef,
      'postDocRef': instance.postDocRef,
      'postTitle': instance.postTitle,
      'notificationType': instance.notificationType,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
