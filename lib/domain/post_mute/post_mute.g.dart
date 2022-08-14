// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostMute _$$_PostMuteFromJson(Map<String, dynamic> json) => _$_PostMute(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCreatorUid: json['postCreatorUid'] as String,
      postDocRef: json['postDocRef'],
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$$_PostMuteToJson(_$_PostMute instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCreatorUid': instance.postCreatorUid,
      'postDocRef': instance.postDocRef,
      'postId': instance.postId,
    };
