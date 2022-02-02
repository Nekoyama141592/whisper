// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_reply.g.dart';

@JsonSerializable()
class LikeReply {
  LikeReply({
    required this.activeUid,
    required this.createdAt,
    required this.replyId,
    required this.tokenId,
    required this.tokenType,
    required this.postCommentReplyDocRef
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String replyId;
  final String tokenId;
  final String tokenType;
  final dynamic postCommentReplyDocRef;

  factory LikeReply.fromJson(Map<String,dynamic> json) => _$LikeReplyFromJson(json);

  Map<String,dynamic> toJson() => _$LikeReplyToJson(this);
}