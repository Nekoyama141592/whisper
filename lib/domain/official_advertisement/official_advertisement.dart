// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement.g.dart';

@JsonSerializable()
class OfficialAdvertisement {
  OfficialAdvertisement({
    required this.createdAt,
    required this.impressionCount,
    required this.impressionCountLimit,
    required this.link,
    required this.officialAdvertisementId,
    required this.subTitle,
    required this.tapCount,
    required this.tapCountLimit,
    required this.title,
    required this.updatedAt
  });
  final dynamic createdAt;
  final int impressionCount;
  final int impressionCountLimit;
  final String link;
  final String officialAdvertisementId;
  final String subTitle;
  final int tapCount;
  final int tapCountLimit;
  final String title;
  final dynamic updatedAt;

  factory OfficialAdvertisement.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementToJson(this);
}