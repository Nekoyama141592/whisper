// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Following _$$_FollowingFromJson(Map<String, dynamic> json) => _$_Following(
      createdAt: json['createdAt'],
      myUid: json['myUid'] as String,
      passiveUid: json['passiveUid'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$$_FollowingToJson(_$_Following instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'myUid': instance.myUid,
      'passiveUid': instance.passiveUid,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
    };
