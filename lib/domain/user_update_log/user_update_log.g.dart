// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateLog _$UserUpdateLogFromJson(Map<String, dynamic> json) =>
    UserUpdateLog(
      bio: json['bio'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      imageURL: json['imageURL'] as String,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$UserUpdateLogToJson(UserUpdateLog instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'imageURL': instance.imageURL,
      'links': instance.links,
      'searchToken': instance.searchToken,
      'uid': instance.uid,
      'userName': instance.userName,
    };
