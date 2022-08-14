import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_post.freezed.dart';
part 'bookmark_post.g.dart';

@freezed
abstract class BookmarkPost with _$BookmarkPost {
 const factory BookmarkPost({
  required String activeUid,
  required dynamic createdAt,
  required String passiveUid,
  required String postId,
  required String tokenId,
  required String tokenType,
  required String bookmarkPostCategoryId,
  }) = _BookmarkPost;
 factory BookmarkPost.fromJson(Map<String, dynamic> json) => _$BookmarkPostFromJson(json);
}