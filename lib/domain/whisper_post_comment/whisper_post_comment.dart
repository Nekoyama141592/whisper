import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_post_comment.freezed.dart';
part 'whisper_post_comment.g.dart';

@freezed
abstract class WhisperPostComment with _$WhisperPostComment {
 const factory WhisperPostComment({
    required String accountName,
    required String comment,
    required String commentLanguageCode,
    required double commentPositiveScore,
    required double commentNegativeScore,
    required String commentSentiment,
    required dynamic createdAt,
    required int followerCount,
    required bool isHidden,
    required bool isNFTicon,
    required bool isOfficial,
    required bool isPinned,
    required int likeCount,
    required bool masterReplied,
    required String mainWalletAddress,
    required int muteCount,
    required Map<String,dynamic> nftIconInfo,
    required String passiveUid,
    required String postCommentId,
    required String postId,
    required int postCommentReplyCount,
    required int reportCount,
    required double score,
    required String uid,
    required dynamic updatedAt,
    required String userImageURL,
    required double userImageNegativeScore,
    required String userName,
    required String userNameLanguageCode,
    required double userNameNegativeScore,
    required double userNamePositiveScore,
    required String userNameSentiment,
  }) = _Timeline;
 factory WhisperPostComment.fromJson(Map<String, dynamic> json) => _$WhisperPostCommentFromJson(json);
}