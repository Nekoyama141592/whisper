// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperUser _$WhisperUserFromJson(Map<String, dynamic> json) => WhisperUser(
      accountName: json['accountName'] as String,
      createdAt: json['createdAt'],
      description: json['description'] as String,
      dmState: json['dmState'] as String,
      followerCount: json['followerCount'] as int,
      followingCount: json['followingCount'] as int,
      imageURL: json['imageURL'] as String,
      isSuspended: json['isSuspended'] as bool,
      isDelete: json['isDelete'] as bool,
      isKeyAccount: json['isKeyAccount'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      recommendState: json['recommendState'] as String,
      score: json['score'] as num,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      totalAsset: (json['totalAsset'] as num).toDouble(),
      userName: json['userName'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      walletAddress: json['walletAddress'] as String,
    );

Map<String, dynamic> _$WhisperUserToJson(WhisperUser instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'createdAt': instance.createdAt,
      'description': instance.description,
      'dmState': instance.dmState,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'imageURL': instance.imageURL,
      'isSuspended': instance.isSuspended,
      'isDelete': instance.isDelete,
      'isKeyAccount': instance.isKeyAccount,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'links': instance.links,
      'recommendState': instance.recommendState,
      'score': instance.score,
      'searchToken': instance.searchToken,
      'totalAsset': instance.totalAsset,
      'userName': instance.userName,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'walletAddress': instance.walletAddress,
    };
