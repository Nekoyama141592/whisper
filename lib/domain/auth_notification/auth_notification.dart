import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_notification.freezed.dart';
part 'auth_notification.g.dart';

@freezed
abstract class AuthNotification with _$AuthNotification {
 const factory AuthNotification({
    required dynamic createdAt,
    required String notificationId,
    required String notificationType,
    required String text,
  }) = _AuthNotification;
 factory AuthNotification.fromJson(Map<String, dynamic> json) => _$AuthNotificationFromJson(json);
}