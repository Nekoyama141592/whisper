// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_like.g.dart';

@JsonSerializable()
class CommentLike {
  CommentLike({
    required this.activeUid,
    required this.createdAt,
    required this.commentId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String commentId;

  factory CommentLike.fromJson(Map<String,dynamic> json) => _$CommentLikeFromJson(json);

  Map<String,dynamic> toJson() => _$CommentLikeToJson(this);
}