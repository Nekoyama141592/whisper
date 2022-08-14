import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_update_log.freezed.dart';
part 'post_update_log.g.dart';

@freezed
abstract class PostUpdateLog with _$PostUpdateLog {
 const factory PostUpdateLog({
    required String commentsState,
    required String country,
    required String description,
    required String genre,
    required List<String> hashTags,
    required List<String> imageURLs,
    required bool isPinned,
    required List<Map<String,dynamic>> links,
    required String postState,
    required String postId,
    required List<String> tagAccountNames,
    required Map<String,dynamic> searchToken,
    required String title,
    required String uid,
    required dynamic updatedAt,
  }) = _PostUpdateLog;
 factory PostUpdateLog.fromJson(Map<String, dynamic> json) => _$PostUpdateLogFromJson(json);
}