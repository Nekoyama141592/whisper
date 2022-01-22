// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_notification.g.dart';

@JsonSerializable()
class CommentNotification {
  CommentNotification({
    required this.uid
  });
  final String uid;

  factory CommentNotification.fromJson(Map<String,dynamic> json) => _$CommentNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$CommentNotificationToJson(this);
}