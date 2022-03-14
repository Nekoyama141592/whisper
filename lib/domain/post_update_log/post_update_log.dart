// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_update_log.g.dart';

@JsonSerializable()
class PostUpdateLog {
  PostUpdateLog({
    required this.commentsState,
    required this.country,
    required this.description,
    required this.genre,
    required this.hashTags,
    required this.imageURLs,
    required this.isPinned,
    required this.language,
    required this.links,
    required this.postState,
    required this.postId,
    required this.tagAccountNames,
    required this.searchToken,
    required this.title,
    required this.uid,
    required this.updatedAt
  });
  
  String commentsState;
  final String country;
  String description;
  String genre;
  List<String> hashTags;
  List<String> imageURLs;
  bool isPinned;
  final String language;
  List<Map<String,dynamic>> links;
  String postState;
  String postId;
  List<String> tagAccountNames;
  Map<String,dynamic> searchToken;
  String title;
  final String uid;
  dynamic updatedAt;
  
  factory PostUpdateLog.fromJson(Map<String,dynamic> json) => _$PostUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$PostUpdateLogToJson(this);
}