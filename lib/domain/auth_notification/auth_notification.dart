// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_notification.g.dart';

@JsonSerializable()
class AuthNotification{
  AuthNotification({
    required this.createdAt,
    required this.notificationId,
    required this.notificationType,
    required this.text,
  });
  final dynamic createdAt;
  final String notificationId;
  final String notificationType;
  final String text;
  
  factory AuthNotification.fromJson(Map<String,dynamic> json) => _$AuthNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$AuthNotificationToJson(this);
}