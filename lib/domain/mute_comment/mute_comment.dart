// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_comment.g.dart';

@JsonSerializable()
class MuteComment {
  MuteComment({
    required this.createdAt,
    required this.commentId,
  });
  
  final dynamic createdAt;
  final String commentId;

  factory MuteComment.fromJson(Map<String,dynamic> json) => _$MuteCommentFromJson(json);

  Map<String,dynamic> toJson() => _$MuteCommentToJson(this);
}