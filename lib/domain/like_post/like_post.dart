// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_post.g.dart';

@JsonSerializable()
class LikePost{
  LikePost({
    required this.activeUid,
    required this.createdAt,
    required this.passiveUid,
    required this.postId,
    required this.tokenId,
    required this.tokenType,
  });
  final String activeUid;
  final dynamic createdAt;
  final String passiveUid;
  final String postId;
  final String tokenId;
  final String tokenType;
  
  factory LikePost.fromJson(Map<String,dynamic> json) => _$LikePostFromJson(json);

  Map<String,dynamic> toJson() => _$LikePostToJson(this);
}