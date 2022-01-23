// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_adsense.g.dart';

@JsonSerializable()
class OfficialAdsense {
  OfficialAdsense({
    required this.displaySeconds,
    required this.intervalSeconds,
    required this.link,
    required this.subTitle,
    required this.title
  });
  final int displaySeconds;
  final int intervalSeconds;
  final String link;
  final String subTitle;
  final String title;

  factory OfficialAdsense.fromJson(Map<String,dynamic> json) => _$OfficialAdsenseFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdsenseToJson(this);
}