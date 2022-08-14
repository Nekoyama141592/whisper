import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_post_category.freezed.dart';
part 'bookmark_post_category.g.dart';

@freezed
abstract class BookmarkPostCategory with _$BookmarkPostCategory {
 const factory BookmarkPostCategory({
    required dynamic createdAt,
    required String categoryName,
    required String tokenId,
    required String tokenType,
    required String imageURL,
    required String uid,
    required dynamic updatedAt,
  }) = _BookmarkPostCategory;
 factory BookmarkPostCategory.fromJson(Map<String, dynamic> json) => _$BookmarkPostCategoryFromJson(json);
}