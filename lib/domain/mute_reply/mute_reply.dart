// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_reply.g.dart';

@JsonSerializable()
class MuteReply {
  MuteReply({
    required this.createdAt,
    required this.replyId,
  });
  
  final dynamic createdAt;
  final String replyId;

  factory MuteReply.fromJson(Map<String,dynamic> json) => _$MuteReplyFromJson(json);

  Map<String,dynamic> toJson() => _$MuteReplyToJson(this);
}