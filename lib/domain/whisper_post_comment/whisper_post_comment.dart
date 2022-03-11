// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_post_comment.g.dart';

@JsonSerializable()
class WhisperPostComment {
  WhisperPostComment({
    required this.accountName,
    required this.comment,
    required this.postCommentId,
    required this.createdAt,
    required this.followerCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.likeCount,
    required this.masterReplied,
    required this.negativeScore,
    required this.passiveUid,
    required this.positiveScore,
    required this.postId,
    required this.postCommentReplyCount,
    required this.score,
    required this.uid,
    required this.updatedAt,
    required this.userName,
    required this.userImageURL
  });
  final String accountName;
  final String comment;
  final dynamic createdAt;
  final int followerCount;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final int likeCount;
  final bool masterReplied;
  final num negativeScore;
  final String passiveUid;
  final num positiveScore;
  final String postCommentId;
  final String postId;
  final int postCommentReplyCount;
  final num score;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  final String userImageURL;
  factory WhisperPostComment.fromJson(Map<String,dynamic> json) => _$WhisperPostCommentFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperPostCommentToJson(this);
}