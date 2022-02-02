// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_comment.g.dart';

@JsonSerializable()
class MuteComment {
  MuteComment({
    required this.activeUid,
    required this.createdAt,
    required this.postCommentId,
    required this.tokenId,
    required this.tokenType,
    required this.postCommentDocRef
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCommentId;
  final String tokenId;
  final String tokenType;
  final dynamic postCommentDocRef;

  factory MuteComment.fromJson(Map<String,dynamic> json) => _$MuteCommentFromJson(json);

  Map<String,dynamic> toJson() => _$MuteCommentToJson(this);
}