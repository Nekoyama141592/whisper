// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.accountName,
    required this.blockCount,
    required this.bio,
    required this.bioNegativeScore,
    required this.bioPostiveScore,
    required this.bioSentiment,
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
    required this.mainWalletAddress,
    required this.muteCount,
    required this.nftIconInfo,
    required this.postCount,
    required this.recommendState,
    required this.reportCount,
    required this.score,
    required this.searchToken,
    required this.totalAsset,
    required this.userName,
    required this.userNameNegativeScore,
    required this.userNamePostiveScore,
    required this.userNameSentiment,
    required this.uid,
    required this.updatedAt,
    required this.walletAddresses,
    required this.walletConnected
  });
  
  String accountName;
  String bio;
  final num bioNegativeScore;
  final num bioPostiveScore; 
  final String bioSentiment;
  final int blockCount;
  final dynamic createdAt;
  String dmState;
  int followerCount;
  int followingCount;
  String userImageURL;
  final bool isAdmin;
  final bool isDelete;
  final bool isGovernmentOfficial;
  bool isKeyAccount;
  bool isNFTicon;
  final bool isOfficial;
  final bool isSuspended;
  List<Map<String,dynamic>> links;
  final String mainWalletAddress;
  final int muteCount;
  final Map<String,dynamic> nftIconInfo;
  int postCount;
  String recommendState;
  final int reportCount;
  final num score;
  Map<String,dynamic> searchToken;
  final num totalAsset;
  final String uid;
  dynamic updatedAt;
  String userName;
  final num userNameNegativeScore;
  final num userNamePostiveScore;
  final String userNameSentiment;
  List<Map<String,dynamic>> walletAddresses;
  bool walletConnected;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}