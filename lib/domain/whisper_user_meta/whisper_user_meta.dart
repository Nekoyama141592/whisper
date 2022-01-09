// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user_meta.g.dart';

@JsonSerializable()
class WhisperUserMeta {
  WhisperUserMeta({
    required this.bookmarks,
    required this.gender,
    required this.isAdmin,
    required this.isDelete,
    required this.likedComments,
    required this.likedReplys,
    required this.likes,
    required this.language,
    required this.readNotifications,
    required this.readPosts,
    required this.searchHistory,
  });
  final List<dynamic> bookmarks;
  final String gender;
  final bool isAdmin;
  final bool isDelete;
  final List<dynamic> likedComments;
  final List<dynamic> likedReplys;
  final List<dynamic> likes;
  final String language;
  final List<dynamic> readNotifications;
  final List<dynamic> readPosts;
  final List<dynamic> searchHistory;
  factory WhisperUserMeta.fromJson(Map<String,dynamic> json) => _$WhisperUserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserMetaToJson(this);
}