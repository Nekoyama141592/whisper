// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUser _$BlockUserFromJson(Map<String, dynamic> json) => BlockUser(
      createdAt: json['createdAt'],
      ipv6: json['ipv6'] as String,
      tokenId: json['tokenId'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$BlockUserToJson(BlockUser instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'ipv6': instance.ipv6,
      'tokenId': instance.tokenId,
      'uid': instance.uid,
    };
