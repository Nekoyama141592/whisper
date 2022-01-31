// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'watchlist.g.dart';

@JsonSerializable()
class Watchlist {
  Watchlist({
    required this.createdAt,
    required this.label,
    required this.watchlistId,
    required this.tokenId,
    required this.uids,
    required this.myUid,
    required this.updatedAt
  });
  final dynamic createdAt;
  final String label;
  final String myUid;
  final String tokenType = watchlistTokenType;
  final String watchlistId;
  final String tokenId;
  final List<String> uids;
  final dynamic updatedAt;

  factory Watchlist.fromJson(Map<String,dynamic> json) => _$WatchlistFromJson(json);

  Map<String,dynamic> toJson() => _$WatchlistToJson(this);
}