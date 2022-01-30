// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline.g.dart';

@JsonSerializable()
class Timeline {
  Timeline({
    required this.createdAt,
    required this.creatorUid,
    required this.isRead,
    required this.postId,
  });
  
  final dynamic createdAt;
  final String creatorUid;
  bool isRead;
  final String postId;
  
  factory Timeline.fromJson(Map<String,dynamic> json) => _$TimelineFromJson(json);

  Map<String,dynamic> toJson() => _$TimelineToJson(this);
}