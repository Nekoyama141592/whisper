// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_notification.g.dart';

@JsonSerializable()
class ReplyNotification {
  ReplyNotification({
    required this.accountName,
    required this.activeUid,
    required this.comment,
    required this.createdAt,
    required this.postCommentId,
    required this.followerCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isRead,
    required this.mainWalletAddress,
    required this.masterReplied,
    required this.nftIconInfo,
    required this.notificationId,
    required this.passiveUid,
    required this.postId,
    required this.postCommentDocRef,
    required this.postCommentReplyId,
    required this.postDocRef,
    required this.notificationType,
    required this.reply,
    required this.replyLanguageCode,
    required this.replyNegativeScore,
    required this.replyPositiveScore,
    required this.replySentiment,
    required this.replyScore,
    required this.updatedAt,
    required this.userImageURL,
    required this.userImageNegativeScore,
    required this.userName,
    required this.userNameLanguageCode,
    required this.userNameNegativeScore,
    required this.userNamePositiveScore,
    required this.userNameSentiment,
  });
  final String accountName;
  final String activeUid;
  final String comment;
  final dynamic createdAt;
  final String postCommentId;
  final int followerCount;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  bool isRead;
  final String mainWalletAddress;
  final bool masterReplied;
  final Map<String,dynamic> nftIconInfo;
  final String notificationId;
  final String passiveUid;
  final String postId;
  final String reply;
  final String replyLanguageCode;
  final num replyNegativeScore;
  final num replyPositiveScore;
  final String replySentiment;
  final num replyScore;
  final String postCommentReplyId;
  final dynamic postCommentDocRef;
  final dynamic postDocRef;
  final String notificationType;
  final dynamic updatedAt;
  final String userImageURL;
  final num userImageNegativeScore;
  final String userName;
  final String userNameLanguageCode;
  final num userNameNegativeScore;
  final num userNamePositiveScore;
  final String userNameSentiment;

  factory ReplyNotification.fromJson(Map<String,dynamic> json) => _$ReplyNotificationFromJson(json);

  Map<String,dynamic> toJson() => _$ReplyNotificationToJson(this);
}