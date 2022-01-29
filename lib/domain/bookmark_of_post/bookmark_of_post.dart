// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_of_post.g.dart';

@JsonSerializable()
class BookmarkOfPost {
  BookmarkOfPost({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postId;

  factory BookmarkOfPost.fromJson(Map<String,dynamic> json) => _$BookmarkOfPostFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkOfPostToJson(this);
}