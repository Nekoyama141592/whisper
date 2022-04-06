// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentReport _$PostCommentReportFromJson(Map<String, dynamic> json) =>
    PostCommentReport(
      activeUid: json['activeUid'] as String,
      comment: json['comment'] as String,
      commentLanguageCode: json['commentLanguageCode'] as String,
      commentNegativeScore: json['commentNegativeScore'] as num,
      commentPositiveScore: json['commentPositiveScore'] as num,
      commentSentiment: json['commentSentiment'] as String,
      createdAt: json['createdAt'],
      others: json['others'] as String,
      reportContent: json['reportContent'] as String,
      passiveUid: json['passiveUid'] as String,
      passiveUserName: json['passiveUserName'] as String,
      postCommentDocRef: json['postCommentDocRef'],
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$PostCommentReportToJson(PostCommentReport instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'comment': instance.comment,
      'commentLanguageCode': instance.commentLanguageCode,
      'commentPositiveScore': instance.commentPositiveScore,
      'commentNegativeScore': instance.commentNegativeScore,
      'commentSentiment': instance.commentSentiment,
      'createdAt': instance.createdAt,
      'others': instance.others,
      'reportContent': instance.reportContent,
      'passiveUid': instance.passiveUid,
      'passiveUserName': instance.passiveUserName,
      'postCommentDocRef': instance.postCommentDocRef,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
    };
