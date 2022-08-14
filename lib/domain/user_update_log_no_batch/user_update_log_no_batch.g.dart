// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log_no_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserUpdateLogNoBatch _$$_UserUpdateLogNoBatchFromJson(
        Map<String, dynamic> json) =>
    _$_UserUpdateLogNoBatch(
      bio: json['bio'] as String,
      dmState: json['dmState'] as String,
      isKeyAccount: json['isKeyAccount'] as bool,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      updatedAt: json['updatedAt'],
      uid: json['uid'] as String,
      walletAddresses: (json['walletAddresses'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$_UserUpdateLogNoBatchToJson(
        _$_UserUpdateLogNoBatch instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'dmState': instance.dmState,
      'isKeyAccount': instance.isKeyAccount,
      'links': instance.links,
      'updatedAt': instance.updatedAt,
      'uid': instance.uid,
      'walletAddresses': instance.walletAddresses,
    };
