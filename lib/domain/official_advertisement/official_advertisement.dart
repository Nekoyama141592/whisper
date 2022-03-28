// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement.g.dart';

@JsonSerializable()
class OfficialAdvertisement {
  OfficialAdvertisement({
    required this.backgroundBlue,
    required this.backgroundGreen,
    required this.backgroundOpacity,
    required this.backgroundRed,
    required this.createdAt,
    required this.impressionCount,
    required this.impressionCountLimit,
    required this.isWhiteText,
    required this.officialAdvertisementId,
    required this.title,
    required this.updatedAt,
    required this.url,
  });
  final int backgroundBlue;
  final int backgroundGreen;
  final double backgroundOpacity;
  final int backgroundRed;
  final dynamic createdAt;
  final int impressionCount;
  final int impressionCountLimit;
  final bool isWhiteText;
  final String officialAdvertisementId;
  final String title;
  final dynamic updatedAt;
  final String url;

  factory OfficialAdvertisement.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementToJson(this);
}