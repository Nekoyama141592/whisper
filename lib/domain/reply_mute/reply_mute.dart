import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_mute.freezed.dart';
part 'reply_mute.g.dart';

@freezed
abstract class ReplyMute with _$ReplyMute {
 const factory ReplyMute({
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyCreatorUid,
    required String postCommentReplyId,
    required dynamic postCommentReplyDocRef,
  }) = _ReplyMute;
 factory ReplyMute.fromJson(Map<String, dynamic> json) => _$ReplyMuteFromJson(json);
}