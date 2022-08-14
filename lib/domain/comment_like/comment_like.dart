import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_like.freezed.dart';
part 'comment_like.g.dart';

@freezed
abstract class CommentLike with _$CommentLike {
 const factory CommentLike({
  required String activeUid,
  required dynamic createdAt,
  required String postCommentCreatorUid,
  required dynamic postCommentDocRef,
  required String postId,
  required String postCommentId,
  }) = _CommentLike;
 factory CommentLike.fromJson(Map<String, dynamic> json) => _$CommentLikeFromJson(json);
}