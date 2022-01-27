// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.g.dart';

@JsonSerializable()
class Bookmark {
  Bookmark({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postId;

  factory Bookmark.fromJson(Map<String,dynamic> json) => _$BookmarkFromJson(json);

  Map<String,dynamic> toJson() => _$BookmarkToJson(this);
}