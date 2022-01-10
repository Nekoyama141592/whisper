// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_many_update_user.g.dart';

@JsonSerializable()
class WhisperManyUpdateUser {
  WhisperManyUpdateUser({
    required this.authNotifications,
    required this.blocksIpv6AndUids,
    required this.description,
    required this.followerCount,
    required this.imageURL,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.link,
    required this.mutesIpv6AndUids,
    required this.noDisplayWords,
    required this.otherLinks,
    required this.recommendState,
    required this.score,
    required this.userName,
    required this.uid,
    required this.walletAddress
  });

  final List<dynamic> authNotifications;
  final List<dynamic> blocksIpv6AndUids;
  final String description;
  final int followerCount;
  final String imageURL;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final String link;
  final List<dynamic> mutesIpv6AndUids;
  final List<dynamic> noDisplayWords;
  final List<dynamic> otherLinks;
  final String recommendState;
  final double score;
  final String userName;
  final String uid;
  final String walletAddress;

  factory WhisperManyUpdateUser.fromJson(Map<String,dynamic> json) => _$WhisperManyUpdateUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperManyUpdateUserToJson(this);
}