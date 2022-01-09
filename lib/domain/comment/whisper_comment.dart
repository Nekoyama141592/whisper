// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_comment.g.dart';

@JsonSerializable()
class WhisperComment {
  WhisperComment({
    required this.comment,
    required this.commentId,
    required this.followerCount,
    required this.ipv6,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.likesUidCount,
    required this.negativeScore,
    required this.passiveUid,
    required this.positiveScore,
    required this.postId,
    required this.replyCount,
    required this.score,
    required this.subUserName,
    required this.uid,
    required this.userName,
    required this.userImageURL
  });
  final String comment;
  final String commentId;
  final int followerCount;
  final String ipv6;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final int likesUidCount;
  final double negativeScore;
  final String passiveUid;
  final double positiveScore;
  final String postId;
  final int replyCount;
  final double score;
  final String subUserName;
  final String uid;
  final String userName;
  final String userImageURL;
  factory WhisperComment.fromJson(Map<String,dynamic> json) => _$WhisperCommentFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperCommentToJson(this);
}