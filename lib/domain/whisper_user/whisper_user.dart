// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.accountName,
    required this.createdAt,
    required this.description,
    required this.dmState,
    required this.followerCount,
    required this.imageURL,
    required this.isBanned,
    required this.isDelete,
    required this.isKeyAccount,
    required this.isNFTicon,
    required this.isOfficial,
    required this.links,
    required this.recommendState,
    required this.score,
    required this.storageImageName,
    required this.tokenToSearch,
    required this.userName,
    required this.uid,
    required this.updatedAt,
    required this.walletAddress
  });
  String accountName;
  dynamic createdAt;
  String description;
  String dmState;
  int followerCount;
  String imageURL;
  bool isBanned;
  bool isDelete;
  bool isKeyAccount;
  bool isNFTicon;
  bool isOfficial;
  List<Map<String,dynamic>> links;
  String recommendState;
  num score;
  String storageImageName;
  Map<String,dynamic> tokenToSearch;
  String userName;
  String uid;
  dynamic updatedAt;
  String walletAddress;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}