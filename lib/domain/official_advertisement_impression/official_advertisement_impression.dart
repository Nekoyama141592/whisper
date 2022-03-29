// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement_impression.g.dart';

@JsonSerializable()
class OfficialAdvertisementImpression{
  OfficialAdvertisementImpression({
    required this.createdAt,
    required this.isDarkTheme,
    required this.officialAdvertisementId,
    required this.uid
  });
  final dynamic createdAt;
  final bool isDarkTheme;
  final String officialAdvertisementId;
  final String uid;
  
  factory OfficialAdvertisementImpression.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementImpressionFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementImpressionToJson(this);
}
