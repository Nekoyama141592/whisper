// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Watchlist _$$_WatchlistFromJson(Map<String, dynamic> json) => _$_Watchlist(
      createdAt: json['createdAt'],
      label: json['label'] as String,
      myUid: json['myUid'] as String,
      tokenType: json['tokenType'] as String,
      watchlistId: json['watchlistId'] as String,
      tokenId: json['tokenId'] as String,
      uids: (json['uids'] as List<dynamic>).map((e) => e as String).toList(),
      updatedAt: json['updatedAt'],
      watchlistRef: json['watchlistRef'],
    );

Map<String, dynamic> _$$_WatchlistToJson(_$_Watchlist instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'label': instance.label,
      'myUid': instance.myUid,
      'tokenType': instance.tokenType,
      'watchlistId': instance.watchlistId,
      'tokenId': instance.tokenId,
      'uids': instance.uids,
      'updatedAt': instance.updatedAt,
      'watchlistRef': instance.watchlistRef,
    };
