// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.authNotifications,
    required this.birthDay,
    required this.createdAt,
    required this.followingUids,
    required this.gender,
    required this.isAdmin,
    required this.isDelete,
    required this.likeComments,
    required this.likeReplys,
    required this.likes,
    required this.language,
    required this.readPosts,
    required this.searchHistory,
    required this.uid,
    required this.updatedAt,
  });
  List<dynamic> authNotifications;
  dynamic birthDay;
  dynamic createdAt;
  List<dynamic> followingUids;
  String gender;
  bool isAdmin;
  bool isDelete;
  List<dynamic> likeComments;
  List<dynamic> likeReplys;
  List<dynamic> likes;
  String language;
  List<dynamic> readPosts;
  List<dynamic> searchHistory;
  String uid;
  dynamic updatedAt;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}