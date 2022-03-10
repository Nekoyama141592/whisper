// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement_config.g.dart';

@JsonSerializable()
class OfficialAdvertisementConfig {
  OfficialAdvertisementConfig({
    required this.createdAt,
    required this.displaySeconds,
    required this.intervalSeconds,
    required this.updatedAt
  });
  final dynamic createdAt;
  final int displaySeconds;
  final int intervalSeconds;
  final dynamic updatedAt;

  factory OfficialAdvertisementConfig.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementConfigFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementConfigToJson(this);
}