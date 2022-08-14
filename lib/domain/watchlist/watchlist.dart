import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist.freezed.dart';
part 'watchlist.g.dart';

@freezed
abstract class Watchlist with _$Watchlist {
 const factory Watchlist({
    required dynamic createdAt,
    required String label,
    required String myUid,
    required String tokenType,
    required String watchlistId,
    required String tokenId,
    required List<String> uids,
    required dynamic updatedAt,
    required dynamic watchlistRef,
  }) = _Watchlist;
 factory Watchlist.fromJson(Map<String, dynamic> json) => _$WatchlistFromJson(json);
}