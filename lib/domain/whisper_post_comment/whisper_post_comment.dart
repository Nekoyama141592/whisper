// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_post_comment.g.dart';

@JsonSerializable()
class WhisperPostComment {
  WhisperPostComment({
    required this.accountName,
    required this.comment,
    required this.commentLanguageCode,
    required this.commentNegativeScore,
    required this.commentPositiveScore,
    required this.commentSentiment,
    required this.createdAt,
    required this.followerCount,
    required this.isHidden,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.likeCount,
    required this.masterReplied,
    required this.mainWalletAddress,
    required this.muteCount,
    required this.nftIconInfo,
    required this.passiveUid,
    required this.postCommentId,
    required this.postId,
    required this.postCommentReplyCount,
    required this.reportCount,
    required this.score,
    required this.uid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userName,
    required this.userNameLanguageCode,
    required this.userNameNegativeScore,
    required this.userNamePositiveScore,
    required this.userNameSentiment,
  });
  final String accountName;
  final String comment;
  final String commentLanguageCode;
  final num commentPositiveScore;
  final num commentNegativeScore;
  final String commentSentiment;
  final dynamic createdAt;
  final int followerCount;
  final bool isHidden;
  final bool isNFTicon;
  final bool isOfficial;
  bool isPinned;
  int likeCount;
  final bool masterReplied;
  final String mainWalletAddress;
  final int muteCount;
  final Map<String,dynamic> nftIconInfo;
  final String passiveUid;
  final String postCommentId;
  final String postId;
  final int postCommentReplyCount;
  final int reportCount;
  final num score;
  final String uid;
  final dynamic updatedAt;
  final String userImageURL;
  final String userName;
  final String userNameLanguageCode;
  final num userNameNegativeScore;
  final num userNamePositiveScore;
  final String userNameSentiment;

  factory WhisperPostComment.fromJson(Map<String,dynamic> json) => _$WhisperPostCommentFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperPostCommentToJson(this);
}