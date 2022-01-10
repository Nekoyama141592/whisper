// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.description,
    required this.dmState,
    required this.imageURL,
    required this.isDelete,
    required this.isKeyAccount,
    required this.isNFTicon,
    required this.isOfficial,
    required this.link,
    required this.otherLinks,
    required this.recommendState,
    required this.storageImageName,
    required this.subUserName,
    required this.userName,
    required this.uid,
    required this.walletAddress
  });
  final String description;
  final String dmState;
  final String imageURL;
  final bool isDelete;
  final bool isKeyAccount;
  final bool isNFTicon;
  final bool isOfficial;
  final String link;
  final List<dynamic> otherLinks;
  final String recommendState;
  final String storageImageName;
  final String subUserName;
  final String userName;
  final String uid;
  final String walletAddress;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}