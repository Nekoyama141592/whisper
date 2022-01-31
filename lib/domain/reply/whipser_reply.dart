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
    required this.ipv6,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.likeCount,
    required this.negativeScore,
    required this.passiveUid,
    required this.postId,
    required this.positiveScore,
    required this.reply,
    required this.postCommentReplyId,
    required this.score,
    required this.uid,
    required this.updatedAt,
    required this.userName,
    required this.userImageURL
  });
  final String accountName;
  final dynamic createdAt;
  final String postCommentId;
  final int followerCount;
  final String ipv6;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final int likeCount;
  final num negativeScore;
  final String passiveUid;
  final String postId;
  final num positiveScore;
  final String reply;
  final String postCommentReplyId;
  final num score;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  final String userImageURL;

  factory WhisperReply.fromJson(Map<String,dynamic> json) => _$WhisperReplyFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperReplyToJson(this);
}