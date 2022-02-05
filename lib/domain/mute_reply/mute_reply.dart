// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_reply.g.dart';

@JsonSerializable()
class MuteReply {
  MuteReply({
    required this.activeUid,
    required this.createdAt,
    required this.postCommentReplyId,
    required this.tokenType,
    required this.postCommentReplyDocRef
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCommentReplyId;
  final String tokenType;
  final dynamic postCommentReplyDocRef;

  factory MuteReply.fromJson(Map<String,dynamic> json) => _$MuteReplyFromJson(json);

  Map<String,dynamic> toJson() => _$MuteReplyToJson(this);
}