// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement.g.dart';

@JsonSerializable()
class OfficialAdvertisement {
  OfficialAdvertisement({
    required this.backGroundOpacity,
    required this.createdAt,
    required this.backGroundHex16DarkTheme,
    required this.textHex16DarkTheme,
    required this.fontsize,
    required this.backGroundHex16LightTheme,
    required this.textHex16LightTheme,
    required this.impressionCount,
    required this.impressionCountLimit,
    required this.officialAdvertisementId,
    required this.textOpacity,
    required this.title,
    required this.updatedAt,
    required this.url,
  });
  final String backGroundHex16DarkTheme;
  final String backGroundHex16LightTheme;
  final double backGroundOpacity;
  final dynamic createdAt;
  final double fontsize; // default 14.0
  final int impressionCount;
  final int impressionCountLimit;
  final String officialAdvertisementId;
  final String textHex16DarkTheme;
  final String textHex16LightTheme;
  final double textOpacity;
  final String title;
  final dynamic updatedAt;
  final String url;

  factory OfficialAdvertisement.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementToJson(this);
}