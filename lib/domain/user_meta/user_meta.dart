// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.authNotifications,
    required this.bookmarks,
    required this.followingUids,
    required this.gender,
    required this.isAdmin,
    required this.isDelete,
    required this.likeComments,
    required this.likeReplys,
    required this.likes,
    required this.language,
    required this.readNotifications,
    required this.readPosts,
    required this.searchHistory,
  });
  final List<dynamic> authNotifications;
  final List<dynamic> bookmarks;
  final List<dynamic> followingUids;
  final String gender;
  final bool isAdmin;
  final bool isDelete;
  final List<dynamic> likeComments;
  final List<dynamic> likeReplys;
  final List<dynamic> likes;
  final String language;
  final List<dynamic> readNotifications;
  final List<dynamic> readPosts;
  final List<dynamic> searchHistory;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}