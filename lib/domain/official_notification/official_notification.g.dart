// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialNotification _$OfficialNotificationFromJson(
        Map<String, dynamic> json) =>
    OfficialNotification(
      createdAt: json['createdAt'],
      notificationId: json['notificationId'] as String,
    );

Map<String, dynamic> _$OfficialNotificationToJson(
        OfficialNotification instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'notificationId': instance.notificationId,
    };
