// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperImage _$WhisperImageFromJson(Map<String, dynamic> json) => WhisperImage(
      description: json['description'] as String,
      imageURL: json['imageURL'] as String,
      label: json['label'] as String,
      storageImageName: json['storageImageName'] as String,
    );

Map<String, dynamic> _$WhisperImageToJson(WhisperImage instance) =>
    <String, dynamic>{
      'description': instance.description,
      'imageURL': instance.imageURL,
      'label': instance.label,
      'storageImageName': instance.storageImageName,
    };
