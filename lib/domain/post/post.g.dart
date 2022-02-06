// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      accountName: json['accountName'] as String,
      audioURL: json['audioURL'] as String,
      bookmarkCount: json['bookmarkCount'] as int,
      commentCount: json['commentCount'] as int,
      commentsState: json['commentsState'] as String,
      country: json['country'] as String,
      createdAt: json['createdAt'],
      description: json['description'] as String,
      genre: json['genre'] as String,
      hashTags:
          (json['hashTags'] as List<dynamic>).map((e) => e as String).toList(),
      imageURLs:
          (json['imageURLs'] as List<dynamic>).map((e) => e as String).toList(),
      impression: json['impression'] as int,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      likeCount: json['likeCount'] as int,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      negativeScore: json['negativeScore'] as num,
      playCount: json['playCount'] as int,
      postId: json['postId'] as String,
      positiveScore: json['positiveScore'] as num,
      postCommentCount: json['postCommentCount'] as int,
      score: json['score'] as num,
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
      'commentCount': instance.commentCount,
      'commentsState': instance.commentsState,
      'country': instance.country,
      'createdAt': instance.createdAt,
      'description': instance.description,
      'genre': instance.genre,
      'hashTags': instance.hashTags,
      'imageURLs': instance.imageURLs,
      'impression': instance.impression,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isPinned': instance.isPinned,
      'likeCount': instance.likeCount,
      'links': instance.links,
      'negativeScore': instance.negativeScore,
      'playCount': instance.playCount,
      'postCommentCount': instance.postCommentCount,
      'postId': instance.postId,
      'positiveScore': instance.positiveScore,
      'score': instance.score,
      'tagAccountNames': instance.tagAccountNames,
      'searchToken': instance.searchToken,
      'title': instance.title,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
