import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement_impression.freezed.dart';
part 'official_advertisement_impression.g.dart';

@freezed
abstract class OfficialAdvertisementImpression with _$OfficialAdvertisementImpression {
 const factory OfficialAdvertisementImpression({
    required dynamic createdAt,
    required bool isDarkTheme,
    required String officialAdvertisementId,
    required String uid,
  }) = _OfficialAdvertisementImpression;
 factory OfficialAdvertisementImpression.fromJson(Map<String, dynamic> json) => _$OfficialAdvertisementImpressionFromJson(json);
}