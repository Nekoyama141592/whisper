// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AuthNotification _$$_AuthNotificationFromJson(Map<String, dynamic> json) =>
    _$_AuthNotification(
      createdAt: json['createdAt'],
      notificationId: json['notificationId'] as String,
      notificationType: json['notificationType'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$_AuthNotificationToJson(_$_AuthNotification instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'notificationId': instance.notificationId,
      'notificationType': instance.notificationType,
      'text': instance.text,
    };
