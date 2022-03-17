// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.accountName,
    required this.bio,
    required this.createdAt,
    required this.dmState,
    required this.followerCount,
    required this.followingCount,
    required this.userImageURL,
    required this.isAdmin,
    required this.isSuspended,
    required this.isDelete,
    required this.isGovernmentOfficial,
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
    required this.mainWalletAddress,
    required this.walletAddresses,
    required this.walletConnected
  });
  String accountName;
  String bio;
  dynamic createdAt;
  String dmState;
  int followerCount;
  int followingCount;
  String userImageURL;
  bool isAdmin;
  bool isDelete;
  bool isGovernmentOfficial;
  bool isKeyAccount;
  bool isNFTicon;
  bool isOfficial;
  final bool isSuspended;
  List<Map<String,dynamic>> links;
  String mainWalletAddress;
  int postCount;
  String recommendState;
  num score;
  Map<String,dynamic> searchToken;
  num totalAsset;
  final String uid;
  dynamic updatedAt;
  String userName;
  List<Map<String,dynamic>> walletAddresses;
  bool walletConnected;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}