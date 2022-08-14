import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_mute.freezed.dart';
part 'user_mute.g.dart';

@freezed
abstract class UserMute with _$UserMute {
 const factory UserMute({
    required dynamic createdAt,
    required String mutedUid,
    required String muterUid,
  }) = _UserMute;
 factory UserMute.fromJson(Map<String, dynamic> json) => _$UserMuteFromJson(json);
}