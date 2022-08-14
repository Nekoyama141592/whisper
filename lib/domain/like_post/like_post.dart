import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_post.freezed.dart';
part 'like_post.g.dart';

@freezed
abstract class LikePost with _$LikePost {
 const factory LikePost({
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required String postId,
    required String tokenId,
    required String tokenType,
  }) = _LikePost;
 factory LikePost.fromJson(Map<String, dynamic> json) => _$LikePostFromJson(json);
}