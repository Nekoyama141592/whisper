// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_post_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BookmarkPostCategory _$$_BookmarkPostCategoryFromJson(
        Map<String, dynamic> json) =>
    _$_BookmarkPostCategory(
      createdAt: json['createdAt'],
      categoryName: json['categoryName'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      imageURL: json['imageURL'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$$_BookmarkPostCategoryToJson(
        _$_BookmarkPostCategory instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'categoryName': instance.categoryName,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'imageURL': instance.imageURL,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
