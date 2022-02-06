// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_like.g.dart';

@JsonSerializable()
class ReplyLike {
  ReplyLike({
    required this.activeUid,
    required this.createdAt,
    required this.postCommentReplyId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCommentReplyId;

  factory ReplyLike.fromJson(Map<String,dynamic> json) => _$ReplyLikeFromJson(json);

  Map<String,dynamic> toJson() => _$ReplyLikeToJson(this);
}