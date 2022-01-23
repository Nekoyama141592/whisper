// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTOwner _$NFTOwnerFromJson(Map<String, dynamic> json) => NFTOwner(
      createdAt: json['createdAt'],
      ethPrice: (json['ethPrice'] as num).toDouble(),
      link: json['link'] as String,
      number: json['number'] as int,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$NFTOwnerToJson(NFTOwner instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'ethPrice': instance.ethPrice,
      'link': instance.link,
      'number': instance.number,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
