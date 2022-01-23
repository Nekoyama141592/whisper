// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_notification.g.dart';

@JsonSerializable()
class CommentNotification {
  CommentNotification({
    required this.accountName,
    required this.comment,
    required this.commentId,
    required this.commentScore,
    required this.createdAt,
    required this.followerCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.notificationId,
    required this.passiveUid,
    required this.postTitle,
    required this.postId,
    required this.uid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userName
  });
  final String accountName;
  final String comment;
  final String commentId;
  final double commentScore;
  final dynamic createdAt;
  final int followerCount;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final String notificationId;
  final String passiveUid;
  final String postTitle;
  final String postId;
  final String uid;
  final dynamic updatedAt;
  final String userImageURL;
  final String userName;

  factory CommentNotification.fromJson(Map<String,dynamic> json) => _$CommentNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$CommentNotificationToJson(this);
}