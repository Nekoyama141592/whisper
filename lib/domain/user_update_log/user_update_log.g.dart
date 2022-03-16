// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateLog _$UserUpdateLogFromJson(Map<String, dynamic> json) =>
    UserUpdateLog(
      accountName: json['accountName'] as String,
      mainWalletAddress: json['mainWalletAddress'] as String,
      recommendState: json['recommendState'] as String,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      updatedAt: json['updatedAt'],
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$UserUpdateLogToJson(UserUpdateLog instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'mainWalletAddress': instance.mainWalletAddress,
      'recommendState': instance.recommendState,
      'searchToken': instance.searchToken,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
