// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperUser _$WhisperUserFromJson(Map<String, dynamic> json) => WhisperUser(
      description: json['description'] as String,
      dmState: json['dmState'] as String,
      isDelete: json['isDelete'] as bool,
      isKeyAccount: json['isKeyAccount'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      link: json['link'] as String,
      otherLinks: json['otherLinks'] as List<dynamic>,
      recommendState: json['recommendState'] as String,
      storageImageName: json['storageImageName'] as String,
      subUserName: json['subUserName'] as String,
      userName: json['userName'] as String,
      uid: json['uid'] as String,
      walletAddress: json['walletAddress'] as String,
    );

Map<String, dynamic> _$WhisperUserToJson(WhisperUser instance) =>
    <String, dynamic>{
      'description': instance.description,
      'dmState': instance.dmState,
      'isDelete': instance.isDelete,
      'isKeyAccount': instance.isKeyAccount,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'link': instance.link,
      'otherLinks': instance.otherLinks,
      'recommendState': instance.recommendState,
      'storageImageName': instance.storageImageName,
      'subUserName': instance.subUserName,
      'userName': instance.userName,
      'uid': instance.uid,
      'walletAddress': instance.walletAddress,
    };
