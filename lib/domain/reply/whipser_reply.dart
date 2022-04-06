// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whipser_reply.g.dart';

@JsonSerializable()
class WhisperReply {
  WhisperReply({
    required this.accountName,
    required this.createdAt,
    required this.postCommentId,
    required this.followerCount,
    required this.isHidden,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.likeCount,
    required this.mainWalletAddress,
    required this.muteCount,
    required this.nftIconInfo,
    required this.passiveUid,
    required this.postId,
    required this.reply,
    required this.replyLanguageCode,
    required this.replyNegativeScore,
    required this.replyPositiveScore,
    required this.replySentiment,
    required this.postCommentReplyId,
    required this.postCreatorUid,
    required this.postDocRef,
    required this.reportCount,
    required this.score,
    required this.uid,
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
  final dynamic createdAt;
  final int followerCount;
  final bool isHidden;
  final bool isNFTicon;
  final bool isOfficial;
  bool isPinned;
  int likeCount;
  final String mainWalletAddress;
  final int muteCount;
  final Map<String,dynamic> nftIconInfo;
  final String passiveUid;
  final String postId;
  final String reply;
  final String replyLanguageCode;
  final double replyNegativeScore;
  final double replyPositiveScore;
  final String replySentiment;
  final String postCommentId;
  final String postCommentReplyId;
  final String postCreatorUid;
  final dynamic postDocRef;
  final int reportCount;
  final double score;
  final String uid;
  final dynamic updatedAt;
  final String userImageURL;
  final double userImageNegativeScore;
  final String userName;
  final String userNameLanguageCode;
  final double userNameNegativeScore;
  final double userNamePositiveScore;
  final String userNameSentiment;

  factory WhisperReply.fromJson(Map<String,dynamic> json) => _$WhisperReplyFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperReplyToJson(this);
}