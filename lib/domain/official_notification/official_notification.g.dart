// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Timeline _$$_TimelineFromJson(Map<String, dynamic> json) => _$_Timeline(
      createdAt: json['createdAt'],
      notificationId: json['notificationId'] as String,
      notificationType: json['notificationType'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$$_TimelineToJson(_$_Timeline instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'notificationId': instance.notificationId,
      'notificationType': instance.notificationType,
      'text': instance.text,
    };
