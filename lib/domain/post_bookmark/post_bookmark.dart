import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_bookmark.freezed.dart';
part 'post_bookmark.g.dart';

@freezed
abstract class PostBookmark with _$PostBookmark {
 const factory PostBookmark({
    required String activeUid,
    required dynamic createdAt,
    required String postCreatorUid,
    required dynamic postDocRef,
    required String postId,
  }) = _PostBookmark;
 factory PostBookmark.fromJson(Map<String, dynamic> json) => _$PostBookmarkFromJson(json);
}