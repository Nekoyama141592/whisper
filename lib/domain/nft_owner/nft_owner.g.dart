// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTOwner _$NFTOwnerFromJson(Map<String, dynamic> json) => NFTOwner(
      createdAt: json['createdAt'],
      lastEthPrice: (json['lastEthPrice'] as num).toDouble(),
      lastUsdPrice: (json['lastUsdPrice'] as num).toDouble(),
      link: json['link'] as String,
      number: json['number'] as int,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$NFTOwnerToJson(NFTOwner instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'lastEthPrice': instance.lastEthPrice,
      'lastUsdPrice': instance.lastUsdPrice,
      'link': instance.link,
      'number': instance.number,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
