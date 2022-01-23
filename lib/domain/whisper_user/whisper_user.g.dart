// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperUser _$WhisperUserFromJson(Map<String, dynamic> json) => WhisperUser(
      accountName: json['accountName'] as String,
      blocksIpv6AndUids: json['blocksIpv6AndUids'] as List<dynamic>,
      description: json['description'] as String,
      dmState: json['dmState'] as String,
      followerCount: json['followerCount'] as int,
      imageURL: json['imageURL'] as String,
      isBanned: json['isBanned'] as bool,
      isDelete: json['isDelete'] as bool,
      isKeyAccount: json['isKeyAccount'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      link: json['link'] as String,
      mutesIpv6AndUids: json['mutesIpv6AndUids'] as List<dynamic>,
      noDisplayWords: json['noDisplayWords'] as List<dynamic>,
      otherLinks: json['otherLinks'] as List<dynamic>,
      recommendState: json['recommendState'] as String,
      score: (json['score'] as num).toDouble(),
      storageImageName: json['storageImageName'] as String,
      tokenToSearch: json['tokenToSearch'] as Map<String, dynamic>,
      userName: json['userName'] as String,
      uid: json['uid'] as String,
      walletAddress: json['walletAddress'] as String,
    );

Map<String, dynamic> _$WhisperUserToJson(WhisperUser instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'blocksIpv6AndUids': instance.blocksIpv6AndUids,
      'description': instance.description,
      'dmState': instance.dmState,
      'followerCount': instance.followerCount,
      'imageURL': instance.imageURL,
      'isBanned': instance.isBanned,
      'isDelete': instance.isDelete,
      'isKeyAccount': instance.isKeyAccount,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'link': instance.link,
      'mutesIpv6AndUids': instance.mutesIpv6AndUids,
      'noDisplayWords': instance.noDisplayWords,
      'otherLinks': instance.otherLinks,
      'recommendState': instance.recommendState,
      'score': instance.score,
      'storageImageName': instance.storageImageName,
      'tokenToSearch': instance.tokenToSearch,
      'userName': instance.userName,
      'uid': instance.uid,
      'walletAddress': instance.walletAddress,
    };
