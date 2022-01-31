// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'mute_comment.g.dart';

@JsonSerializable()
class MuteComment {
  MuteComment({
    required this.activeUid,
    required this.createdAt,
    required this.commentId,
    required this.tokenId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String commentId;
  final String tokenId;
  final String tokenType = muteCommentTokenType;

  factory MuteComment.fromJson(Map<String,dynamic> json) => _$MuteCommentFromJson(json);

  Map<String,dynamic> toJson() => _$MuteCommentToJson(this);
}