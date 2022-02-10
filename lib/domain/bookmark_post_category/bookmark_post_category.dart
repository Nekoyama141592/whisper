// packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'bookmark_post_category.g.dart';

@JsonSerializable()
class BookmarkPostCategory {
  BookmarkPostCategory({
    required this.createdAt,
    required this.label,
    required this.tokenId,
    required this.tokenType,
    required this.imageURL,
    required this.uid,
    required this.updatedAt
  });
  
  final dynamic createdAt;
  String label;
  final String tokenId;
  final String tokenType;
  String imageURL;
  final String uid;
  final dynamic updatedAt;

  factory BookmarkPostCategory.fromJson(Map<String,dynamic> json) => _$BookmarkPostCategoryFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkPostCategoryToJson(this);
}