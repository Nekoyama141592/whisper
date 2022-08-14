import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_report.freezed.dart';
part 'post_comment_report.g.dart';

@freezed
abstract class PostCommentReport with _$PostCommentReport {
 const factory PostCommentReport({
    required String activeUid,
    required String comment,
    required String commentLanguageCode,
    required num commentPositiveScore,
    required num commentNegativeScore,
    required String commentSentiment,
    required dynamic createdAt,
    required String others,
    required String reportContent,
    required String passiveUid,
    required String passiveUserName,
    required dynamic postCommentDocRef,
    required String postCreatorUid,
    required String postId,
  }) = _PostCommentReport;
 factory PostCommentReport.fromJson(Map<String, dynamic> json) => _$PostCommentReportFromJson(json);
}