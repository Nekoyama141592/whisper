// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist.g.dart';

@JsonSerializable()
class Watchlist {
  Watchlist({
    required this.createdAt,
    required this.label,
    required this.watchlistId,
    required this.uids,
    required this.myUid,
    required this.updatedAt
  });
  final dynamic createdAt;
  final String label;
  final String watchlistId;
  final List<dynamic> uids;
  final String myUid;
  final dynamic updatedAt;

  factory Watchlist.fromJson(Map<String,dynamic> json) => _$WatchlistFromJson(json);

  Map<String,dynamic> toJson() => _$WatchlistToJson(this);
}