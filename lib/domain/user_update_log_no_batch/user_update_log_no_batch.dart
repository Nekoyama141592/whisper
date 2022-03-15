// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log_no_batch.g.dart';

@JsonSerializable()
class UserUpdateLogNoBatch {
  UserUpdateLogNoBatch({
    required this.bio,
    required this.dmState,
    required this.isKeyAccount,
    required this.links,
    required this.updatedAt,
    required this.walletAddresses,
  });
  final String bio;
  final String dmState;
  final bool isKeyAccount;
  final List<Map<String,dynamic>> links;
  final dynamic updatedAt;
  final List<Map<String,dynamic>> walletAddresses;
  
  factory UserUpdateLogNoBatch.fromJson(Map<String,dynamic> json) => _$UserUpdateLogNoBatchFromJson(json);

  Map<String,dynamic> toJson() => _$UserUpdateLogNoBatchToJson(this);
}