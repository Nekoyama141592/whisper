// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// 
import 'package:whisper/constants/strings.dart';

part 'mute_reply.g.dart';

@JsonSerializable()
class MuteReply {
  MuteReply({
    required this.activeUid,
    required this.createdAt,
    required this.replyId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String replyId;
  final String tokenType = muteReplyTokenType;

  factory MuteReply.fromJson(Map<String,dynamic> json) => _$MuteReplyFromJson(json);

  Map<String,dynamic> toJson() => _$MuteReplyToJson(this);
}