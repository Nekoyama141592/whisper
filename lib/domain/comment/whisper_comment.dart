// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_comment.g.dart';

@JsonSerializable()
class WhisperComment {
  WhisperComment({
    required this.accountName,
    required this.comment,
    required this.postCommentId,
    required this.createdAt,
    required this.followerCount,
    required this.ipv6,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.likeCount,
    required this.negativeScore,
    required this.passiveUid,
    required this.positiveScore,
    required this.postId,
    required this.replyCount,
    required this.score,
    required this.uid,
    required this.updatedAt,
    required this.userName,
    required this.userImageURL
  });
  final String accountName;
  final String comment;
  final String postCommentId;
  final dynamic createdAt;
  final int followerCount;
  final String ipv6;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final int likeCount;
  final num negativeScore;
  final String passiveUid;
  final num positiveScore;
  final String postId;
  final int replyCount;
  final num score;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  final String userImageURL;
  factory WhisperComment.fromJson(Map<String,dynamic> json) => _$WhisperCommentFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperCommentToJson(this);
}