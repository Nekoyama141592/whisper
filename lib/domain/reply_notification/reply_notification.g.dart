// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyNotification _$ReplyNotificationFromJson(Map<String, dynamic> json) =>
    ReplyNotification(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      elementId: json['elementId'] as String,
      elementState: json['elementState'] as String,
      followerCount: json['followerCount'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      notificationId: json['notificationId'] as String,
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      reply: json['reply'] as String,
      replyScore: (json['replyScore'] as num).toDouble(),
      replyId: json['replyId'] as String,
      uid: json['uid'] as String,
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$ReplyNotificationToJson(ReplyNotification instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'comment': instance.comment,
      'elementId': instance.elementId,
      'elementState': instance.elementState,
      'followerCount': instance.followerCount,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'notificationId': instance.notificationId,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'reply': instance.reply,
      'replyScore': instance.replyScore,
      'replyId': instance.replyId,
      'uid': instance.uid,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
