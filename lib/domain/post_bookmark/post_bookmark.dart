// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_bookmark.g.dart';

@JsonSerializable()
class PostBookmark {
  PostBookmark({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postId;

  factory PostBookmark.fromJson(Map<String,dynamic> json) => _$PostBookmarkFromJson(json);

  Map<String,dynamic> toJson() => _$PostBookmarkToJson(this);
}