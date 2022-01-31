// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) =>
    SearchHistory(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      searchTerm: json['searchTerm'] as String,
      tokenId: json['tokenId'] as String,
    );

Map<String, dynamic> _$SearchHistoryToJson(SearchHistory instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'searchTerm': instance.searchTerm,
      'tokenId': instance.tokenId,
    };
