// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history.g.dart';

@JsonSerializable()
class SearchHistory {
  SearchHistory({
    required this.activeUid,
    required this.createdAt,
    required this.searchTerm,
    required this.tokenId,
    required this.tokenType,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String searchTerm;
  final String tokenId;
  final String tokenType;

  factory SearchHistory.fromJson(Map<String,dynamic> json) => _$SearchHistoryFromJson(json);

  Map<String,dynamic> toJson() => _$SearchHistoryToJson(this);
}