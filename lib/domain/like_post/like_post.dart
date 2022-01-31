// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'like_post.g.dart';

@JsonSerializable()
class LikePost{
  LikePost({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
    required this.tokenId,
  });
  final String activeUid;
  final dynamic createdAt;
  final String postId;
  final String tokenId;
  final String tokenType = likePostTokenType;
  
  factory LikePost.fromJson(Map<String,dynamic> json) => _$LikePostFromJson(json);

  Map<String,dynamic> toJson() => _$LikePostToJson(this);
}