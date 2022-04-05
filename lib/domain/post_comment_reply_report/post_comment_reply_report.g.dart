// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_reply_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentReplyReport _$PostCommentReplyReportFromJson(
        Map<String, dynamic> json) =>
    PostCommentReplyReport(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      others: json['others'] as String,
      reportContent: json['reportContent'] as String,
      passiveUid: json['passiveUid'] as String,
      passiveUserImageURL: json['passiveUserImageURL'] as String,
      passiveUserName: json['passiveUserName'] as String,
      postCommentId: json['postCommentId'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyRef: json['postCommentReplyRef'],
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
      reply: json['reply'] as String,
      replyLanguageCode: json['replyLanguageCode'] as String,
      replyNegativeScore: json['replyNegativeScore'] as num,
      replyPositiveScore: json['replyPositiveScore'] as num,
      replySentiment: json['replySentiment'] as String,
    );

Map<String, dynamic> _$PostCommentReplyReportToJson(
        PostCommentReplyReport instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'others': instance.others,
      'reportContent': instance.reportContent,
      'passiveUid': instance.passiveUid,
      'passiveUserImageURL': instance.passiveUserImageURL,
      'passiveUserName': instance.passiveUserName,
      'postCommentId': instance.postCommentId,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyRef': instance.postCommentReplyRef,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
      'reply': instance.reply,
      'replyLanguageCode': instance.replyLanguageCode,
      'replyNegativeScore': instance.replyNegativeScore,
      'replyPositiveScore': instance.replyPositiveScore,
      'replySentiment': instance.replySentiment,
    };
