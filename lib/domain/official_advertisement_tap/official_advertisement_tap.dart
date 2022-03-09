// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'official_advertisement_tap.g.dart';

@JsonSerializable()
class OfficialAdvertisementTap{
  OfficialAdvertisementTap({
    required this.createdAt,
    required this.officialAdvertisementId,
    required this.uid
  });
  final dynamic createdAt;
  final String officialAdvertisementId;
  final String uid;
  
  factory OfficialAdvertisementTap.fromJson(Map<String,dynamic> json) => _$OfficialAdvertisementTapFromJson(json);

  Map<String,dynamic> toJson() => _$OfficialAdvertisementTapToJson(this);
}