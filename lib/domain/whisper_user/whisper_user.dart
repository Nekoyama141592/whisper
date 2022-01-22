// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_user.g.dart';

@JsonSerializable()
class WhisperUser {
  WhisperUser({
    required this.accountName,
    required this.blocksIpv6AndUids,
    required this.description,
    required this.dmState,
    required this.followerCount,
    required this.imageURL,
    required this.isDelete,
    required this.isKeyAccount,
    required this.isNFTicon,
    required this.isOfficial,
    required this.link,
    required this.mutesIpv6AndUids,
    required this.noDisplayWords,
    required this.otherLinks,
    required this.recommendState,
    required this.score,
    required this.storageImageName,
    required this.userName,
    required this.uid,
    required this.walletAddress
  });
  final String accountName;
  final List<dynamic> blocksIpv6AndUids;
  final String description;
  final String dmState;
  final int followerCount;
  final String imageURL;
  final bool isDelete;
  final bool isKeyAccount;
  final bool isNFTicon;
  final bool isOfficial;
  final String link;
  final List<dynamic> mutesIpv6AndUids;
  final List<dynamic> noDisplayWords;
  final List<dynamic> otherLinks;
  final String recommendState;
  final double score;
  final String storageImageName;
  final String userName;
  final String uid;
  final String walletAddress;

  factory WhisperUser.fromJson(Map<String,dynamic> json) => _$WhisperUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperUserToJson(this);
}