// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkLabel _$BookmarkLabelFromJson(Map<String, dynamic> json) =>
    BookmarkLabel(
      createdAt: json['createdAt'],
      label: json['label'] as String,
      bookmarkLabelId: json['bookmarkLabelId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      imageURL: json['imageURL'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$BookmarkLabelToJson(BookmarkLabel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'label': instance.label,
      'bookmarkLabelId': instance.bookmarkLabelId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'imageURL': instance.imageURL,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
