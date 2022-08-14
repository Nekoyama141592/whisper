import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_owner.freezed.dart';
part 'nft_owner.g.dart';

@freezed
abstract class NFTOwner with _$NFTOwner {
 const factory NFTOwner({
    required dynamic createdAt,
    required double lastEthPrice,
    required double lastUsdPrice,
    required String link,
    required int number,
    required String uid,
    required dynamic updatedAt,
    required String userName,
    required String userImageURL,
  }) = _NFTOwner;
 factory NFTOwner.fromJson(Map<String, dynamic> json) => _$NFTOwnerFromJson(json);
}