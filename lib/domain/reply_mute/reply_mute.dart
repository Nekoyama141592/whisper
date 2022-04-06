// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply_mute.g.dart';

@JsonSerializable()
class ReplyMute {
  ReplyMute({
    required this.activeUid,
    required this.createdAt,
    required this.postCommentReplyCreatorUid,
    required this.postCommentReplyId,
    required this.postCommentReplyDocRef
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCommentReplyCreatorUid;
  final String postCommentReplyId;
  final dynamic postCommentReplyDocRef;

  factory ReplyMute.fromJson(Map<String,dynamic> json) => _$ReplyMuteFromJson(json);

  Map<String,dynamic> toJson() => _$ReplyMuteToJson(this);
}