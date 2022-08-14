import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_comment.freezed.dart';
part 'like_comment.g.dart';

@freezed
abstract class LikeComment with _$LikeComment {
 const factory LikeComment({
    required String activeUid,
    required String postCommentId,
    required dynamic createdAt,
    required String tokenId,
    required String tokenType,
    required dynamic postCommentDocRef,
  }) = _LikeComment;
 factory LikeComment.fromJson(Map<String, dynamic> json) => _$LikeCommentFromJson(json);
}