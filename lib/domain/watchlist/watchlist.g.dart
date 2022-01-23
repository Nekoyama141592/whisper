// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watchlist _$WatchlistFromJson(Map<String, dynamic> json) => Watchlist(
      createdAt: json['createdAt'],
      label: json['label'] as String,
      watchlistId: json['watchlistId'] as String,
      uids: json['uids'] as List<dynamic>,
      myUid: json['myUid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$WatchlistToJson(Watchlist instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'label': instance.label,
      'watchlistId': instance.watchlistId,
      'uids': instance.uids,
      'myUid': instance.myUid,
      'updatedAt': instance.updatedAt,
    };
