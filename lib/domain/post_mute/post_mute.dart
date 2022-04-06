// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_mute.g.dart';

@JsonSerializable()
class PostMute {
  PostMute({
    required this.activeUid,
    required this.createdAt,
    required this.postCreatorUid,
    required this.postDocRef,
    required this.postId,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postCreatorUid;
  final dynamic postDocRef;
  final String postId;

  factory PostMute.fromJson(Map<String,dynamic> json) => _$PostMuteFromJson(json);

  Map<String,dynamic> toJson() => _$PostMuteToJson(this);
}