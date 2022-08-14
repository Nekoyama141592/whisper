import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement_config.freezed.dart';
part 'official_advertisement_config.g.dart';

@freezed
abstract class OfficialAdvertisementConfig with _$OfficialAdvertisementConfig {
 const factory OfficialAdvertisementConfig({
    required dynamic createdAt,
    required int intervalSeconds,
    required int timeInSecForIosWeb,
    required dynamic updatedAt,
  }) = _OfficialAdvertisement;
 factory OfficialAdvertisementConfig.fromJson(Map<String, dynamic> json) => _$OfficialAdvertisementConfigFromJson(json);
}