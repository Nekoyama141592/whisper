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
      bookmarks: json['bookmarks'] as dynamic,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$BookmarkLabelToJson(BookmarkLabel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'label': instance.label,
      'bookmarkLabelId': instance.bookmarkLabelId,
      'bookmarks': instance.bookmarks,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };