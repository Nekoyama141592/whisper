import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_reply.freezed.dart';
part 'whisper_reply.g.dart';

@freezed
abstract class WhisperReply with _$WhisperReply {
 const factory WhisperReply({
    required String accountName,
    required dynamic createdAt,
    required int followerCount,
    required bool isHidden,
    required bool isNFTicon,
    required bool isOfficial,
    required bool isPinned,
    required int likeCount,
    required String mainWalletAddress,
    required int muteCount,
    required Map<String,dynamic> nftIconInfo,
    required String passiveUid,
    required String postId,
    required String reply,
    required String replyLanguageCode,
    required double replyNegativeScore,
    required double replyPositiveScore,
    required String replySentiment,
    required String postCommentId,
    required String postCommentReplyId,
    required String postCreatorUid,
    required dynamic postDocRef,
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
  }) = _WhisperReply;
 factory WhisperReply.fromJson(Map<String, dynamic> json) => _$WhisperReplyFromJson(json);
}