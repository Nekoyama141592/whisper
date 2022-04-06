// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_mute.g.dart';

@JsonSerializable()
class CommentMute {
  CommentMute({
    required this.activeUid,
    required this.createdAt,
    required this.postCommentId,
    required this.postId,
    required this.postCommentCreatorUid,
    required this.postCommentDocRef
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCommentCreatorUid;
  final dynamic postCommentDocRef;
  final String postId;
  final String postCommentId;

  factory CommentMute.fromJson(Map<String,dynamic> json) => _$CommentMuteFromJson(json);

  Map<String,dynamic> toJson() => _$CommentMuteToJson(this);
}