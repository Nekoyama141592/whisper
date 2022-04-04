// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline.g.dart';
// cloud_functions/functions/index.js

@JsonSerializable()
class Timeline {
  Timeline({
    required this.createdAt,
    required this.isRead,
    required this.postCreatorUid,
    required this.postId,
    required this.userImageURL,
    required this.userName
  });
  
  final dynamic createdAt;
  bool isRead;
  final String postCreatorUid;
  final String postId;
  final String userImageURL;
  final String userName;
  
  factory Timeline.fromJson(Map<String,dynamic> json) => _$TimelineFromJson(json);

  Map<String,dynamic> toJson() => _$TimelineToJson(this);
}