// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'like_reply.g.dart';

@JsonSerializable()
class LikeReply {
  LikeReply({
    required this.activeUid,
    required this.createdAt,
    required this.replyId,
    required this.tokenId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String replyId;
  final String tokenId;
  final String tokenType = likeReplyTokenType;

  factory LikeReply.fromJson(Map<String,dynamic> json) => _$LikeReplyFromJson(json);

  Map<String,dynamic> toJson() => _$LikeReplyToJson(this);
}