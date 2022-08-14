import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_comment.freezed.dart';
part 'mute_comment.g.dart';

@freezed
abstract class MuteComment with _$MuteComment {
 const factory MuteComment({
    required String activeUid,
    required dynamic createdAt,
    required String postCommentId,
    required String tokenId,
    required String tokenType,
    required dynamic postCommentDocRef,
  }) = _MuteComment;
 factory MuteComment.fromJson(Map<String, dynamic> json) => _$MuteCommentFromJson(json);
}