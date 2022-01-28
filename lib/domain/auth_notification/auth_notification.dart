// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'auth_notification.g.dart';

@JsonSerializable()
class AuthNotification{
  AuthNotification({
    required this.createdAt,
  });
  final dynamic createdAt;
  final String notificationType = authNotificationType;
  
  factory AuthNotification.fromJson(Map<String,dynamic> json) => _$AuthNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$AuthNotificationToJson(this);
}