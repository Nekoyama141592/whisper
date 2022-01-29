// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'timeline.g.dart';

@JsonSerializable()
class Timeline {
  Timeline({
    required this.createdAt,
    required this.creatorUid,
    required this.postId,
  });
  
  final dynamic createdAt;
  final String creatorUid;
  final String postId;
  factory Timeline.fromJson(Map<String,dynamic> json) => _$TimelineFromJson(json);

  Map<String,dynamic> toJson() => _$TimelineToJson(this);
}