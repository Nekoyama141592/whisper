// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_update_log.g.dart';

@JsonSerializable()
class PostUpdateLog {
  PostUpdateLog({
    required this.imageURLs,
    required this.postId,
    required this.title,
    required this.searchToken,
    required this.links,
    required this.updatedAt,
    required this.uid
  });
  
  List<String> imageURLs;
  final String postId;
  String title;
  Map<String,dynamic> searchToken;
  List<Map<String,dynamic>> links;
  final dynamic updatedAt;
  final String uid;
  
  factory PostUpdateLog.fromJson(Map<String,dynamic> json) => _$PostUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$PostUpdateLogToJson(this);
}