// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_timeline.g.dart';

@JsonSerializable()
class WatchlistTimeline {
  WatchlistTimeline({
    required this.createdAt,
    required this.postCreatorUid,
    required this.isRead,
    required this.isDelete,
    required this.postId,
    required this.watchlistId
  });
  
  final dynamic createdAt;
  final String postCreatorUid;
  bool isRead;
  bool isDelete;
  final String postId;
  final String watchlistId;
  
  factory WatchlistTimeline.fromJson(Map<String,dynamic> json) => _$WatchlistTimelineFromJson(json);

  Map<String,dynamic> toJson() => _$WatchlistTimelineToJson(this);
}