// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_owner.g.dart';

@JsonSerializable()
class NFTOwner {
  NFTOwner({
    required this.createdAt,
    required this.lastEthPrice,
    required this.lastUsdPrice,
    required this.link,
    required this.number,
    required this.uid,
    required this.updatedAt,
    required this.userName,
    required this.userImageURL
  });
  final dynamic createdAt;
  final double lastEthPrice;
  final double lastUsdPrice;
  final String link;
  final int number;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  final String userImageURL;

  factory NFTOwner.fromJson(Map<String,dynamic> json) => _$NFTOwnerFromJson(json);

  Map<String,dynamic> toJson() => _$NFTOwnerToJson(this);
}