// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_post.g.dart';

@JsonSerializable()
class LikePost{
  LikePost({
    required this.activeUid,
    required this.createdAt,
    required this.postId
  });
  final String activeUid;
  final dynamic createdAt;
  final String postId;
  
  factory LikePost.fromJson(Map<String,dynamic> json) => _$LikePostFromJson(json);

  Map<String,dynamic> toJson() => _$LikePostToJson(this);
}