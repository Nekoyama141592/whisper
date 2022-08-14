import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_post.freezed.dart';
part 'read_post.g.dart';

@freezed
abstract class ReadPost with _$ReadPost {
 const factory ReadPost({
    required String activeUid,
    required dynamic createdAt,
    required String postId,
    required String tokenId,
    required String tokenType,
    required String passiveUid,
  }) = _ReadPost;
 factory ReadPost.fromJson(Map<String, dynamic> json) => _$ReadPostFromJson(json);
}