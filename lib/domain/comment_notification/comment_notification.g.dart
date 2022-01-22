// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentNotification _$CommentNotificationFromJson(Map<String, dynamic> json) =>
    CommentNotification(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      commentId: json['commentId'] as String,
      commentScore: (json['commentScore'] as num).toDouble(),
      followerCount: json['followerCount'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      notificationId: json['notificationId'] as String,
      passiveUid: json['passiveUid'] as String,
      postTitle: json['postTitle'] as String,
      postId: json['postId'] as String,
      uid: json['uid'] as String,
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$CommentNotificationToJson(
        CommentNotification instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'comment': instance.comment,
      'commentId': instance.commentId,
      'commentScore': instance.commentScore,
      'followerCount': instance.followerCount,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'notificationId': instance.notificationId,
      'passiveUid': instance.passiveUid,
      'postTitle': instance.postTitle,
      'postId': instance.postId,
      'uid': instance.uid,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
