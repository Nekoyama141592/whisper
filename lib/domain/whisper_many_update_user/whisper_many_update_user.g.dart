// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_many_update_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperManyUpdateUser _$WhisperManyUpdateUserFromJson(
        Map<String, dynamic> json) =>
    WhisperManyUpdateUser(
      authNotifications: json['authNotifications'] as List<dynamic>,
      blocksIpv6AndUids: json['blocksIpv6AndUids'] as List<dynamic>,
      description: json['description'] as String,
      followerCount: json['followerCount'] as int,
      imageURL: json['imageURL'] as String,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      link: json['link'] as String,
      mutesIpv6AndUids: json['mutesIpv6AndUids'] as List<dynamic>,
      noDisplayWords: json['noDisplayWords'] as List<dynamic>,
      otherLinks: json['otherLinks'] as List<dynamic>,
      recommendState: json['recommendState'] as String,
      score: (json['score'] as num).toDouble(),
      userName: json['userName'] as String,
      uid: json['uid'] as String,
      walletAddress: json['walletAddress'] as String,
    );

Map<String, dynamic> _$WhisperManyUpdateUserToJson(
        WhisperManyUpdateUser instance) =>
    <String, dynamic>{
      'authNotifications': instance.authNotifications,
      'blocksIpv6AndUids': instance.blocksIpv6AndUids,
      'description': instance.description,
      'followerCount': instance.followerCount,
      'imageURL': instance.imageURL,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'link': instance.link,
      'mutesIpv6AndUids': instance.mutesIpv6AndUids,
      'noDisplayWords': instance.noDisplayWords,
      'otherLinks': instance.otherLinks,
      'recommendState': instance.recommendState,
      'score': instance.score,
      'userName': instance.userName,
      'uid': instance.uid,
      'walletAddress': instance.walletAddress,
    };
