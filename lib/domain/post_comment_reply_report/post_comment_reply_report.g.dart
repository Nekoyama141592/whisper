// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_reply_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostCommentReplyReport _$$_PostCommentReplyReportFromJson(
        Map<String, dynamic> json) =>
    _$_PostCommentReplyReport(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      others: json['others'] as String,
      reportContent: json['reportContent'] as String,
      passiveUid: json['passiveUid'] as String,
      passiveUserName: json['passiveUserName'] as String,
      postCommentId: json['postCommentId'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
      reply: json['reply'] as String,
      replyLanguageCode: json['replyLanguageCode'] as String,
      replyNegativeScore: json['replyNegativeScore'] as num,
      replyPositiveScore: json['replyPositiveScore'] as num,
      replySentiment: json['replySentiment'] as String,
    );

Map<String, dynamic> _$$_PostCommentReplyReportToJson(
        _$_PostCommentReplyReport instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'others': instance.others,
      'reportContent': instance.reportContent,
      'passiveUid': instance.passiveUid,
      'passiveUserName': instance.passiveUserName,
      'postCommentId': instance.postCommentId,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
      'reply': instance.reply,
      'replyLanguageCode': instance.replyLanguageCode,
      'replyNegativeScore': instance.replyNegativeScore,
      'replyPositiveScore': instance.replyPositiveScore,
      'replySentiment': instance.replySentiment,
    };
