// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BlockUser _$$_BlockUserFromJson(Map<String, dynamic> json) => _$_BlockUser(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$$_BlockUserToJson(_$_BlockUser instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'passiveUid': instance.passiveUid,
    };
