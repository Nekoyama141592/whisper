// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_like.g.dart';

@JsonSerializable()
class PostLike {
  PostLike({
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

  factory PostLike.fromJson(Map<String,dynamic> json) => _$PostLikeFromJson(json);

  Map<String,dynamic> toJson() => _$PostLikeToJson(this);
}