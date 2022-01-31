// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'mute_post.g.dart';

@JsonSerializable()
class MutePost {
  MutePost({
    required this.activeUid,
    required this.createdAt,
    required this.postId,
    required this.tokenId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String postId;
  final String tokenId;
  final String tokenType = mutePostTokenType;

  factory MutePost.fromJson(Map<String,dynamic> json) => _$MutePostFromJson(json);

  Map<String,dynamic> toJson() => _$MutePostToJson(this);
}