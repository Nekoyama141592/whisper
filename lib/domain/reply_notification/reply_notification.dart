// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_notification.g.dart';

@JsonSerializable()
class ReplyNotification {
  ReplyNotification({
    required this.accountName,
    required this.comment,
    required this.createdAt,
    required this.elementId,
    required this.elementState,
    required this.followerCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isRead,
    required this.notificationId,
    required this.passiveUid,
    required this.postId,
    required this.reply,
    required this.replyScore,
    required this.replyId,
    required this.uid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userName
  });
  final String accountName;
  final String comment;
  final dynamic createdAt;
  final String elementId;
  final String elementState;
  final int followerCount;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  bool isRead;
  final String notificationId;
  final String passiveUid;
  final String postId;
  final String reply;
  final num replyScore;
  final String replyId;
  final String uid;
  final dynamic updatedAt;
  final String userImageURL;
  final String userName;

  factory ReplyNotification.fromJson(Map<String,dynamic> json) => _$ReplyNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$ReplyNotificationToJson(this);
}