// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_post.g.dart';

@JsonSerializable()
class MutePost {
  MutePost({
    required this.createdAt,
    required this.postId,
  });
  
  final dynamic createdAt;
  final String postId;

  factory MutePost.fromJson(Map<String,dynamic> json) => _$MutePostFromJson(json);

  Map<String,dynamic> toJson() => _$MutePostToJson(this);
}