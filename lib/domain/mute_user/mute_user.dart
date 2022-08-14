import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_user.freezed.dart';
part 'mute_user.g.dart';

@freezed
abstract class MuteUser with _$MuteUser {
 const factory MuteUser({
    required String activeUid,
    required dynamic createdAt,
    required String tokenId,
    required String tokenType,
    required String passiveUid,
  }) = _MuteUser;
 factory MuteUser.fromJson(Map<String, dynamic> json) => _$MuteUserFromJson(json);
}