// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user_meta.g.dart';

@JsonSerializable()
class WhisperUserMeta {
  WhisperUserMeta({
    required this.readPosts
  });
  final List<dynamic> readPosts;
  factory WhisperUserMeta.fromJson(Map<String,dynamic> json) => _$WhisperUserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserMetaToJson(this);
}