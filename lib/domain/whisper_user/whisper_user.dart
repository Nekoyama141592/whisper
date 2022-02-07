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
    required this.followingCount,
    required this.imageURL,
    required this.isSuspended,
    required this.isDelete,
    required this.isKeyAccount,
    required this.isNFTicon,
    required this.isOfficial,
    required this.links,
    required this.postCount,
    required this.recommendState,
    required this.score,
    required this.searchToken,
    required this.totalAsset,
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
  int followingCount;
  String imageURL;
  final bool isSuspended;
  bool isDelete;
  bool isKeyAccount;
  bool isNFTicon;
  bool isOfficial;
  List<Map<String,dynamic>> links;
  int postCount;
  String recommendState;
  num score;
  Map<String,dynamic> searchToken;
  num totalAsset;
  String userName;
  final String uid;
  dynamic updatedAt;
  String walletAddress;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}