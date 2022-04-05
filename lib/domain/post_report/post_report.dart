// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_report.g.dart';

@JsonSerializable()
class PostReport {
  PostReport({
    required this.activeUid,
    required this.createdAt,
    required this.others,
    required this.reportContent,
    required this.passiveUid,
    required this.passiveUserImageURL,
    required this.passiveUserName,
    required this.postRef,
    required this.postId,
    required this.postReportId,
    required this.postTitle,
    required this.postTitleLanguageCode,
    required this.postTitleNegativeScore,
    required this.postTitlePositiveScore,
    required this.postTitleSentiment,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String others;
  final String reportContent;
  final String passiveUid;
  final String passiveUserImageURL;
  final String passiveUserName;
  final dynamic postRef;
  final String postId;
  final String postReportId;
  String postTitle;
  final postTitleLanguageCode;
  final num postTitleNegativeScore;
  final num postTitlePositiveScore;
  final String postTitleSentiment;

  factory PostReport.fromJson(Map<String,dynamic> json) => _$PostReportFromJson(json);

  Map<String,dynamic> toJson() => _$PostReportToJson(this);
}