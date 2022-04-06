// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.accountName,
    required this.blockCount,
    required this.bio,
    required this.bioLanguageCode,
    required this.bioNegativeScore,
    required this.bioPositiveScore,
    required this.bioSentiment,
    required this.createdAt,
    required this.dmState,
    required this.followerCount,
    required this.followingCount,
    required this.isAdmin,
    required this.isSuspended,
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
    required this.uid,
    required this.userImageURL,
    required this.userImageNegativeScore,
    required this.userName,
    required this.userNameLanguageCode,
    required this.userNameNegativeScore,
    required this.userNamePositiveScore,
    required this.userNameSentiment,
    required this.updatedAt,
    required this.walletAddresses,
    required this.walletConnected
  });
  
  String accountName;
  String bio;
  // un used
  final String bioLanguageCode;
  final double bioNegativeScore;
  final double bioPositiveScore; 
  final String bioSentiment;
  final int blockCount;
  final dynamic createdAt;
  String dmState;
  int followerCount;
  int followingCount;
  final bool isAdmin;
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
  final double score;
  Map<String,dynamic> searchToken;
  final double totalAsset;
  final String uid;
  dynamic updatedAt;
  String userImageURL;
  final double userImageNegativeScore;
  String userName;
  final String userNameLanguageCode;
  final double userNameNegativeScore;
  final double userNamePositiveScore;
  final String userNameSentiment;
  List<Map<String,dynamic>> walletAddresses;
  bool walletConnected;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}