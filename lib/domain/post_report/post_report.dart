import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_report.freezed.dart';
part 'post_report.g.dart';

@freezed
abstract class PostReport with _$PostReport {
 const factory PostReport({
    required String activeUid,
    required dynamic createdAt,
    required String others,
    required String reportContent,
    required String postCreatorUid,
    required String passiveUserName,
    required dynamic postDocRef,
    required String postId,
    required String postReportId,
    required String postTitle,
    required String postTitleLanguageCode,
    required num postTitleNegativeScore,
    required num postTitlePositiveScore,
    required String postTitleSentiment,
  }) = _PostReport;
 factory PostReport.fromJson(Map<String, dynamic> json) => _$PostReportFromJson(json);
}