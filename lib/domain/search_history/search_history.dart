import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history.freezed.dart';
part 'search_history.g.dart';

@freezed
abstract class SearchHistory with _$SearchHistory {
 const factory SearchHistory({
    required String activeUid,
    required dynamic createdAt,
    required String searchTerm,
    required String tokenId,
    required String tokenType,
  }) = _SearchHistory;
 factory SearchHistory.fromJson(Map<String, dynamic> json) => _$SearchHistoryFromJson(json);
}