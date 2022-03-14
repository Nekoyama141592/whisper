// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log_no_batch.g.dart';

@JsonSerializable()
class UserUpdateLogNoBatch {
  UserUpdateLogNoBatch({
    required this.dmState,
    required this.isKeyAccount,
    required this.links,
    required this.updatedAt,
    required this.walletAddresses,
  });
  String dmState;
  bool isKeyAccount;
  List<Map<String,dynamic>> links;
  final dynamic updatedAt;
  List<Map<String,dynamic>> walletAddresses;
  
  factory UserUpdateLogNoBatch.fromJson(Map<String,dynamic> json) => _$UserUpdateLogNoBatchFromJson(json);

  Map<String,dynamic> toJson() => _$UserUpdateLogNoBatchToJson(this);
}