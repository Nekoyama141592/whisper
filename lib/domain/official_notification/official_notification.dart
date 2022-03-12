// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_notification.g.dart';

@JsonSerializable()
class OfficialNotification{
  OfficialNotification({
    required this.createdAt,
    required this.notificationId,
    required this.notificationType,
    required this.text
  });
  final dynamic createdAt;
  final String notificationId;
  final String notificationType;
  final String text;
  
  factory OfficialNotification.fromJson(Map<String,dynamic> json) => _$OfficialNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialNotificationToJson(this);
}