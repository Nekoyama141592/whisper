// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log.g.dart';

@JsonSerializable()
class UserUpdateLog {
  UserUpdateLog({
    required this.accountName,
    required this.bio,
    required this.imageURL,
    required this.mainWalletAddress,
    required this.recommendState,
    required this.searchToken,
    required this.uid,
    required this.userName,
    required this.updatedAt
  });
  String accountName;
  String bio;
  String imageURL;
  String mainWalletAddress;
  String recommendState;
  Map<String,dynamic> searchToken;
  final String uid;
  dynamic updatedAt;
  String userName;
  
  factory UserUpdateLog.fromJson(Map<String,dynamic> json) => _$UserUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$UserUpdateLogToJson(this);
}