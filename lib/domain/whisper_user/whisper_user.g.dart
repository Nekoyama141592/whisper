// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperUser _$WhisperUserFromJson(Map<String, dynamic> json) => WhisperUser(
      accountName: json['accountName'] as String,
      blockCount: json['blockCount'] as int,
      bio: json['bio'] as String,
      bioLanguageCode: json['bioLanguageCode'] as String,
      bioNegativeScore: json['bioNegativeScore'] as num,
      bioPositiveScore: json['bioPositiveScore'] as num,
      bioSentiment: json['bioSentiment'] as String,
      createdAt: json['createdAt'],
      dmState: json['dmState'] as String,
      followerCount: json['followerCount'] as int,
      followingCount: json['followingCount'] as int,
      userImageURL: json['userImageURL'] as String,
      isAdmin: json['isAdmin'] as bool,
      isSuspended: json['isSuspended'] as bool,
      isGovernmentOfficial: json['isGovernmentOfficial'] as bool,
      isKeyAccount: json['isKeyAccount'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      mainWalletAddress: json['mainWalletAddress'] as String,
      muteCount: json['muteCount'] as int,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      postCount: json['postCount'] as int,
      recommendState: json['recommendState'] as String,
      reportCount: json['reportCount'] as int,
      score: json['score'] as num,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      totalAsset: json['totalAsset'] as num,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      userNameLanguageCode: json['userNameLanguageCode'] as String,
      userNameNegativeScore: json['userNameNegativeScore'] as num,
      userNamePositiveScore: json['userNamePositiveScore'] as num,
      userNameSentiment: json['userNameSentiment'] as String,
      updatedAt: json['updatedAt'],
      walletAddresses: (json['walletAddresses'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      walletConnected: json['walletConnected'] as bool,
    );

Map<String, dynamic> _$WhisperUserToJson(WhisperUser instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'bio': instance.bio,
      'bioLanguageCode': instance.bioLanguageCode,
      'bioNegativeScore': instance.bioNegativeScore,
      'bioPositiveScore': instance.bioPositiveScore,
      'bioSentiment': instance.bioSentiment,
      'blockCount': instance.blockCount,
      'createdAt': instance.createdAt,
      'dmState': instance.dmState,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'isAdmin': instance.isAdmin,
      'isGovernmentOfficial': instance.isGovernmentOfficial,
      'isKeyAccount': instance.isKeyAccount,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isSuspended': instance.isSuspended,
      'links': instance.links,
      'mainWalletAddress': instance.mainWalletAddress,
      'muteCount': instance.muteCount,
      'nftIconInfo': instance.nftIconInfo,
      'postCount': instance.postCount,
      'recommendState': instance.recommendState,
      'reportCount': instance.reportCount,
      'score': instance.score,
      'searchToken': instance.searchToken,
      'totalAsset': instance.totalAsset,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
      'userNameLanguageCode': instance.userNameLanguageCode,
      'userNameNegativeScore': instance.userNameNegativeScore,
      'userNamePositiveScore': instance.userNamePositiveScore,
      'userNameSentiment': instance.userNameSentiment,
      'walletAddresses': instance.walletAddresses,
      'walletConnected': instance.walletConnected,
    };
