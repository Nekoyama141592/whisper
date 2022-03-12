// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_post.g.dart';

@JsonSerializable()
class BookmarkPost {
  BookmarkPost({
    required this.activeUid,
    required this.createdAt,
    required this.passiveUid,
    required this.postId,
    required this.tokenId,
    required this.tokenType,
    required this.bookmarkPostCategoryId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String passiveUid;
  final String postId;
  final String tokenId;
  final String tokenType;
  final String bookmarkPostCategoryId;

  factory BookmarkPost.fromJson(Map<String,dynamic> json) => _$BookmarkPostFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkPostToJson(this);
}