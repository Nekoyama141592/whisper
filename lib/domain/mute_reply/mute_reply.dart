import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_reply.freezed.dart';
part 'mute_reply.g.dart';

@freezed
abstract class MuteReply with _$MuteReply {
 const factory MuteReply({
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyId,
    required String tokenType,
    required dynamic postCommentReplyDocRef,
  }) = _MuteReply;
 factory MuteReply.fromJson(Map<String, dynamic> json) => _$MuteReplyFromJson(json);
}