// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'search_history.g.dart';

@JsonSerializable()
class SearchHistory {
  SearchHistory({
    required this.activeUid,
    required this.createdAt,
    required this.searchTerm,
    required this.tokenId
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String searchTerm;
  final String tokenId;
  final String tokenType = searchHistoryTokenType;

  factory SearchHistory.fromJson(Map<String,dynamic> json) => _$SearchHistoryFromJson(json);

  Map<String,dynamic> toJson() => _$SearchHistoryToJson(this);
}