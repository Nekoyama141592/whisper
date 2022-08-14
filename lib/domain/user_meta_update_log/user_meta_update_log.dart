import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta_update_log.freezed.dart';
part 'user_meta_update_log.g.dart';

@freezed
abstract class UserMetaUpdateLog with _$UserMetaUpdateLog {
 const factory UserMetaUpdateLog({
    required String email,
    required String gender,
    required String ipv6,
    required String uid,
    required dynamic updatedAt,
  }) = _UserMetaUpdateLog;
 factory UserMetaUpdateLog.fromJson(Map<String, dynamic> json) => _$UserMetaUpdateLogFromJson(json);
}