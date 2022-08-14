// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SearchHistory _$$_SearchHistoryFromJson(Map<String, dynamic> json) =>
    _$_SearchHistory(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      searchTerm: json['searchTerm'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$$_SearchHistoryToJson(_$_SearchHistory instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'searchTerm': instance.searchTerm,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
    };
