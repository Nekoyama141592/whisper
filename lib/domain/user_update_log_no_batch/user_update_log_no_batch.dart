import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log_no_batch.freezed.dart';
part 'user_update_log_no_batch.g.dart';

@freezed
abstract class UserUpdateLogNoBatch with _$UserUpdateLogNoBatch {
 const factory UserUpdateLogNoBatch({
    required String bio,
    required String dmState,
    required bool isKeyAccount,
    required List<Map<String,dynamic>> links,
    required dynamic updatedAt,
    required String uid,
    required List<Map<String,dynamic>> walletAddresses,
  }) = _UserUpdateLogNoBatch;
 factory UserUpdateLogNoBatch.fromJson(Map<String, dynamic> json) => _$UserUpdateLogNoBatchFromJson(json);
}