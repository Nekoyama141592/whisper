// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_post.g.dart';

@JsonSerializable()
class ReadPost {
  ReadPost({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
    required this.tokenId,
    required this.tokenType,
    required this.passiveUid
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postId;
  final String tokenId;
  final String tokenType;
  final String passiveUid;

  factory ReadPost.fromJson(Map<String,dynamic> json) => _$ReadPostFromJson(json);

  Map<String,dynamic> toJson() => _$ReadPostToJson(this);
}