// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      audioURL: json['audioURL'] as String,
      commentsState: json['commentsState'] as String,
      country: json['country'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      hashTags: json['hashTags'] as List<dynamic>,
      imageURL: json['imageURL'] as String,
      ipv6: json['ipv6'] as String,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      isPinned: json['isPinned'] as bool,
      link: json['link'] as String,
      noDisplayWords: json['noDisplayWords'] as List<dynamic>,
      noDisplayIpv6AndUids: json['noDisplayIpv6AndUids'] as List<dynamic>,
      otherLinks: json['otherLinks'] as List<dynamic>,
      postId: json['postId'] as String,
      positiveScore: (json['positiveScore'] as num).toDouble(),
      score: (json['score'] as num).toDouble(),
      storageImageName: json['storageImageName'] as String,
      storagePostName: json['storagePostName'] as String,
      tagUids: json['tagUids'] as List<dynamic>,
      title: json['title'] as String,
      uid: json['uid'] as String,
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'audioURL': instance.audioURL,
      'commentsState': instance.commentsState,
      'country': instance.country,
      'description': instance.description,
      'genre': instance.genre,
      'hashTags': instance.hashTags,
      'imageURL': instance.imageURL,
      'ipv6': instance.ipv6,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'isPinned': instance.isPinned,
      'link': instance.link,
      'noDisplayWords': instance.noDisplayWords,
      'noDisplayIpv6AndUids': instance.noDisplayIpv6AndUids,
      'otherLinks': instance.otherLinks,
      'postId': instance.postId,
      'positiveScore': instance.positiveScore,
      'score': instance.score,
      'storageImageName': instance.storageImageName,
      'storagePostName': instance.storagePostName,
      'tagUids': instance.tagUids,
      'title': instance.title,
      'uid': instance.uid,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
