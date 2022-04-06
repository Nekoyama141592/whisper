// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostReport _$PostReportFromJson(Map<String, dynamic> json) => PostReport(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      others: json['others'] as String,
      reportContent: json['reportContent'] as String,
      postCreatorUid: json['postCreatorUid'] as String,
      passiveUserImageURL: json['passiveUserImageURL'] as String,
      passiveUserName: json['passiveUserName'] as String,
      postDocRef: json['postDocRef'],
      postId: json['postId'] as String,
      postReportId: json['postReportId'] as String,
      postTitle: json['postTitle'] as String,
      postTitleLanguageCode: json['postTitleLanguageCode'],
      postTitleNegativeScore: json['postTitleNegativeScore'] as num,
      postTitlePositiveScore: json['postTitlePositiveScore'] as num,
      postTitleSentiment: json['postTitleSentiment'] as String,
    );

Map<String, dynamic> _$PostReportToJson(PostReport instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'others': instance.others,
      'reportContent': instance.reportContent,
      'postCreatorUid': instance.postCreatorUid,
      'passiveUserImageURL': instance.passiveUserImageURL,
      'passiveUserName': instance.passiveUserName,
      'postDocRef': instance.postDocRef,
      'postId': instance.postId,
      'postReportId': instance.postReportId,
      'postTitle': instance.postTitle,
      'postTitleLanguageCode': instance.postTitleLanguageCode,
      'postTitleNegativeScore': instance.postTitleNegativeScore,
      'postTitlePositiveScore': instance.postTitlePositiveScore,
      'postTitleSentiment': instance.postTitleSentiment,
    };
