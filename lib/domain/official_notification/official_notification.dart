// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'official_notification.g.dart';

@JsonSerializable()
class OfficialNotification{
  OfficialNotification({
    required this.createdAt,
    required this.notificationId
  });
  final dynamic createdAt;
  final String notificationId;
  final String notificationType = officialNotificationType;
  
  factory OfficialNotification.fromJson(Map<String,dynamic> json) => _$OfficialNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialNotificationToJson(this);
}