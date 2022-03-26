// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      accountName: json['accountName'] as String,
      audioURL: json['audioURL'] as String,
      bookmarkCount: json['bookmarkCount'] as int,
      commentsState: json['commentsState'] as String,
      country: json['country'] as String,
      createdAt: json['createdAt'],
      description: json['description'] as String,
      genre: json['genre'] as String,
      hashTags:
          (json['hashTags'] as List<dynamic>).map((e) => e as String).toList(),
      imageURLs:
          (json['imageURLs'] as List<dynamic>).map((e) => e as String).toList(),
      impressionCount: json['impressionCount'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      language: json['language'] as String,
      likeCount: json['likeCount'] as int,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      mainWalletAddress: json['mainWalletAddress'] as String,
      negativeScore: json['negativeScore'] as num,
      nftIconInfo: json['nftIconInfo'] as Map<String, dynamic>,
      playCount: json['playCount'] as int,
      postState: json['postState'] as String,
      postId: json['postId'] as String,
      positiveScore: json['positiveScore'] as num,
      postCommentCount: json['postCommentCount'] as int,
      recommendState: json['recommendState'] as String,
      score: json['score'] as num,
      storagePostName: json['storagePostName'] as String,
      tagAccountNames: (json['tagAccountNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'accountName': instance.accountName,
      'audioURL': instance.audioURL,
      'bookmarkCount': instance.bookmarkCount,
      'commentsState': instance.commentsState,
      'country': instance.country,
      'createdAt': instance.createdAt,
      'description': instance.description,
      'genre': instance.genre,
      'hashTags': instance.hashTags,
      'imageURLs': instance.imageURLs,
      'impressionCount': instance.impressionCount,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isPinned': instance.isPinned,
      'language': instance.language,
      'likeCount': instance.likeCount,
      'links': instance.links,
      'mainWalletAddress': instance.mainWalletAddress,
      'negativeScore': instance.negativeScore,
      'nftIconInfo': instance.nftIconInfo,
      'playCount': instance.playCount,
      'postState': instance.postState,
      'postCommentCount': instance.postCommentCount,
      'postId': instance.postId,
      'positiveScore': instance.positiveScore,
      'recommendState': instance.recommendState,
      'score': instance.score,
      'storagePostName': instance.storagePostName,
      'tagAccountNames': instance.tagAccountNames,
      'searchToken': instance.searchToken,
      'title': instance.title,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
