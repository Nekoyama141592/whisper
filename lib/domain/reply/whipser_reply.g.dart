// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whipser_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperReply _$WhisperReplyFromJson(Map<String, dynamic> json) => WhisperReply(
      elementId: json['elementId'] as String,
      elementState: json['elementState'] as String,
      followerCount: json['followerCount'] as int,
      ipv6: json['ipv6'] as String,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      likesUidCount: json['likesUidCount'] as int,
      negativeScore: (json['negativeScore'] as num).toDouble(),
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      positiveScore: (json['positiveScore'] as num).toDouble(),
      reply: json['reply'] as String,
      replyId: json['replyId'] as String,
      score: (json['score'] as num).toDouble(),
      subUserName: json['subUserName'] as String,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$WhisperReplyToJson(WhisperReply instance) =>
    <String, dynamic>{
      'elementId': instance.elementId,
      'elementState': instance.elementState,
      'followerCount': instance.followerCount,
      'ipv6': instance.ipv6,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'likesUidCount': instance.likesUidCount,
      'negativeScore': instance.negativeScore,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'positiveScore': instance.positiveScore,
      'reply': instance.reply,
      'replyId': instance.replyId,
      'score': instance.score,
      'subUserName': instance.subUserName,
      'uid': instance.uid,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
