// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log.g.dart';

@JsonSerializable()
class UserUpdateLog {
  UserUpdateLog({
    required this.accountName,
    required this.imageURL,
    required this.mainWalletAddress,
    required this.recommendState,
    required this.searchToken,
    required this.uid,
    required this.userName,
    required this.updatedAt
  });
  final String accountName;
  final String imageURL;
  final String mainWalletAddress;
  final String recommendState;
  final Map<String,dynamic> searchToken;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  
  factory UserUpdateLog.fromJson(Map<String,dynamic> json) => _$UserUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$UserUpdateLogToJson(this);
}