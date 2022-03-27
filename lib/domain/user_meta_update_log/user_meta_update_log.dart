// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta_update_log.g.dart';

@JsonSerializable()
class UserMetaUpdateLog {
  UserMetaUpdateLog({
    required this.birthDay,
    required this.gender,
    required this.ipv6,
    required this.language,
    required this.uid,
    required this.updatedAt,
  });
  final dynamic birthDay;
  final String gender;
  final String ipv6;
  final String language;
  final String uid;
  final dynamic updatedAt;
  
  factory UserMetaUpdateLog.fromJson(Map<String,dynamic> json) => _$UserMetaUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaUpdateLogToJson(this);
}