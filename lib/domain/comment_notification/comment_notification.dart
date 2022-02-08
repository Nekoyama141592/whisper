// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_notification.g.dart';

@JsonSerializable()
class CommentNotification {
  CommentNotification({
    required this.accountName,
    required this.comment,
    required this.postCommentId,
    required this.commentScore,
    required this.createdAt,
    required this.followerCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isRead,
    required this.notificationId,
    required this.passiveUid,
    required this.postId,
    required this.postCommentDocRef,
    required this.postDocRef,
    required this.postTitle,
    required this.notificationType,
    required this.activeUid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userName
  });
  final String accountName;
  final String activeUid;
  final String comment;
  final String postCommentId;
  final num commentScore;
  final dynamic createdAt;
  final int followerCount;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  bool isRead;
  final String notificationId;
  final String passiveUid;
  final String postId;
  final dynamic postCommentDocRef;
  final dynamic postDocRef;
  final String postTitle;
  final String notificationType;
  final dynamic updatedAt;
  final String userImageURL;
  final String userName;

  factory CommentNotification.fromJson(Map<String,dynamic> json) => _$CommentNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$CommentNotificationToJson(this);
}