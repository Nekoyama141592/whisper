import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_timeline.freezed.dart';
part 'watchlist_timeline.g.dart';

@freezed
abstract class WatchlistTimeline with _$WatchlistTimeline {
 const factory WatchlistTimeline({
    required dynamic createdAt,
    required String postCreatorUid,
    required bool isRead,
    required bool isDelete,
    required String postId,
    required String watchlistId,
  }) = _WatchlistTimeline;
 factory WatchlistTimeline.fromJson(Map<String, dynamic> json) => _$WatchlistTimelineFromJson(json);
}