import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_post.freezed.dart';
part 'mute_post.g.dart';

@freezed
abstract class MutePost with _$MutePost {
 const factory MutePost({
    required String activeUid,
    required dynamic createdAt,
    required String postId,
    required String tokenId,
    required String tokenType,
    required String passiveUid,
  }) = _MutePost;
 factory MutePost.fromJson(Map<String, dynamic> json) => _$MutePostFromJson(json);
}