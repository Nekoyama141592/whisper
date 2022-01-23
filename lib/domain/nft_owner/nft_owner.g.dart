// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NFTOwner _$NFTOwnerFromJson(Map<String, dynamic> json) => NFTOwner(
      ethPrice: (json['ethPrice'] as num).toDouble(),
      link: json['link'] as String,
      number: json['number'] as int,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$NFTOwnerToJson(NFTOwner instance) => <String, dynamic>{
      'ethPrice': instance.ethPrice,
      'link': instance.link,
      'number': instance.number,
      'uid': instance.uid,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
