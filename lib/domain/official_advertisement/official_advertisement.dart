// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement.g.dart';

@JsonSerializable()
class OfficialAdvertisement {
  OfficialAdvertisement({
    required this.createdAt,
    required this.impressionCount,
    required this.displaySeconds,
    required this.intervalSeconds,
    required this.link,
    required this.subTitle,
    required this.tapCount,
    required this.title,
    required this.updatedAt
  });
  final dynamic createdAt;
  final int impressionCount;
  final int displaySeconds;
  final int intervalSeconds;
  final String link;
  final String subTitle;
  final int tapCount;
  final String title;
  final dynamic updatedAt;

  factory OfficialAdvertisement.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementToJson(this);
}