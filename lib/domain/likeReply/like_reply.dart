// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_reply.g.dart';

@JsonSerializable()
class LikeReply {
  LikeReply({
    required this.activeUid,
    required this.createdAt,
    required this.replyId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String replyId;

  factory LikeReply.fromJson(Map<String,dynamic> json) => _$LikeReplyFromJson(json);

  Map<String,dynamic> toJson() => _$LikeReplyToJson(this);
}