// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_update_log.g.dart';

@JsonSerializable()
class UserUpdateLog {
  UserUpdateLog({
    required this.bio,
    required this.links,
    required this.imageURL,
    required this.searchToken,
    required this.uid,
    required this.userName
  });
  
  final String bio;
  final String imageURL;
  final List<Map<String,dynamic>> links;
  final Map<String,dynamic> searchToken;
  final String uid;
  final String userName;
  
  factory UserUpdateLog.fromJson(Map<String,dynamic> json) => _$UserUpdateLogFromJson(json);

  Map<String,dynamic> toJson() => _$UserUpdateLogToJson(this);
}