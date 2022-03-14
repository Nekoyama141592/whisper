// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log_no_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateLogNoBatch _$UserUpdateLogNoBatchFromJson(
        Map<String, dynamic> json) =>
    UserUpdateLogNoBatch(
      dmState: json['dmState'] as String,
      isKeyAccount: json['isKeyAccount'] as bool,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      updatedAt: json['updatedAt'],
      walletAddresses: (json['walletAddresses'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$UserUpdateLogNoBatchToJson(
        UserUpdateLogNoBatch instance) =>
    <String, dynamic>{
      'dmState': instance.dmState,
      'isKeyAccount': instance.isKeyAccount,
      'links': instance.links,
      'updatedAt': instance.updatedAt,
      'walletAddresses': instance.walletAddresses,
    };
