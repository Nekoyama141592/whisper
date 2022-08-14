// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WatchlistTimeline _$$_WatchlistTimelineFromJson(Map<String, dynamic> json) =>
    _$_WatchlistTimeline(
      createdAt: json['createdAt'],
      postCreatorUid: json['postCreatorUid'] as String,
      isRead: json['isRead'] as bool,
      isDelete: json['isDelete'] as bool,
      postId: json['postId'] as String,
      watchlistId: json['watchlistId'] as String,
    );

Map<String, dynamic> _$$_WatchlistTimelineToJson(
        _$_WatchlistTimeline instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'postCreatorUid': instance.postCreatorUid,
      'isRead': instance.isRead,
      'isDelete': instance.isDelete,
      'postId': instance.postId,
      'watchlistId': instance.watchlistId,
    };
