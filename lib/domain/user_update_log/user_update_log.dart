import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log.freezed.dart';
part 'user_update_log.g.dart';

@freezed
abstract class UserUpdateLog with _$UserUpdateLog {
 const factory UserUpdateLog({
    required String accountName,
    required String mainWalletAddress,
    required String recommendState,
    required Map<String,dynamic> searchToken,
    required String uid,
    required dynamic updatedAt,
    required String userName,
    required String userImageURL,
  }) = _Timeline;
 factory UserUpdateLog.fromJson(Map<String, dynamic> json) => _$UserUpdateLogFromJson(json);
}