import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement.freezed.dart';
part 'official_advertisement.g.dart';

@freezed
abstract class OfficialAdvertisement with _$OfficialAdvertisement {
 const factory OfficialAdvertisement({
    required String backGroundHex16DarkTheme,
    required String backGroundHex16LightTheme,
    required double backGroundOpacity,
    required dynamic createdAt,
    required double fontsize, // default 14.0
    required int impressionCount,
    required int impressionCountLimit,
    required String officialAdvertisementId,
    required String textHex16DarkTheme,
    required String textHex16LightTheme,
    required double textOpacity,
    required String title,
    required dynamic updatedAt,
    required String url,
  }) = _OfficialAdvertisement;
 factory OfficialAdvertisement.fromJson(Map<String, dynamic> json) => _$OfficialAdvertisementFromJson(json);
}