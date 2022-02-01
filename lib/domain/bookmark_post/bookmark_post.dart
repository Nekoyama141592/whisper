// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'bookmark_post.g.dart';

@JsonSerializable()
class BookmarkPost {
  BookmarkPost({
    required this.activeUid,
    required this.createdAt,
    required this.passiveUid,
    required this.postId,
    required this.tokenId,
    required this.bookmarkLabelId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String passiveUid;
  final String postId;
  final String tokenId;
  final String tokenType = bookmarkPostTokenType;
  final String bookmarkLabelId;

  factory BookmarkPost.fromJson(Map<String,dynamic> json) => _$BookmarkPostFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkPostToJson(this);
}