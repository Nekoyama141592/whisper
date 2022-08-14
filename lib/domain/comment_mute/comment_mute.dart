import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_mute.freezed.dart';
part 'comment_mute.g.dart';

@freezed
abstract class CommentMute with _$CommentMute {
 const factory CommentMute({
   required String activeUid,
  required dynamic createdAt,
  required String postCommentCreatorUid,
  required dynamic postCommentDocRef,
  required String postId,
  required String postCommentId,
  }) = _CommentMute;
 factory CommentMute.fromJson(Map<String, dynamic> json) => _$CommentMuteFromJson(json);
}