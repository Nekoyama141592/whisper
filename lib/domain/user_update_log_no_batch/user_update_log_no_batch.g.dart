// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log_no_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateLogNoBatch _$UserUpdateLogNoBatchFromJson(
        Map<String, dynamic> json) =>
    UserUpdateLogNoBatch(
      bio: json['bio'] as String,
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
      'bio': instance.bio,
      'dmState': instance.dmState,
      'isKeyAccount': instance.isKeyAccount,
      'links': instance.links,
      'updatedAt': instance.updatedAt,
      'walletAddresses': instance.walletAddresses,
    };
