// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_comment.g.dart';

@JsonSerializable()
class LikeComment {
  LikeComment({
    required this.activeUid,
    required this.postCommentId,
    required this.createdAt,
    required this.tokenId,
    required this.tokenType,
    required this.postCommentDocRef
  });
  
  final String activeUid;
  final String postCommentId;
  final dynamic createdAt;
  final String tokenId;
  final String tokenType;
  final dynamic postCommentDocRef;

  factory LikeComment.fromJson(Map<String,dynamic> json) => _$LikeCommentFromJson(json);

  Map<String,dynamic> toJson() => _$LikeCommentToJson(this);
}