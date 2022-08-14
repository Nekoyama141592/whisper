import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_notification.freezed.dart';
part 'official_notification.g.dart';

@freezed
abstract class OfficialNotification with _$OfficialNotification {
 const factory OfficialNotification({
    required dynamic createdAt,
    required String notificationId,
    required String notificationType,
    required String text,
  }) = _Timeline;
 factory OfficialNotification.fromJson(Map<String, dynamic> json) => _$OfficialNotificationFromJson(json);
}