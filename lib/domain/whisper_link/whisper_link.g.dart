// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperLink _$WhisperLinkFromJson(Map<String, dynamic> json) => WhisperLink(
      description: json['description'] as String,
      imageURL: json['imageURL'] as String,
      label: json['label'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$WhisperLinkToJson(WhisperLink instance) =>
    <String, dynamic>{
      'description': instance.description,
      'imageURL': instance.imageURL,
      'label': instance.label,
      'url': instance.url,
    };
