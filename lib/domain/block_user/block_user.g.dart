// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUser _$BlockUserFromJson(Map<String, dynamic> json) => BlockUser(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      ipv6: json['ipv6'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$BlockUserToJson(BlockUser instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'ipv6': instance.ipv6,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'passiveUid': instance.passiveUid,
    };
