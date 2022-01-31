// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthNotification _$AuthNotificationFromJson(Map<String, dynamic> json) =>
    AuthNotification(
      createdAt: json['createdAt'],
      notificationId: json['notificationId'] as String,
    );

Map<String, dynamic> _$AuthNotificationToJson(AuthNotification instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'notificationId': instance.notificationId,
    };
