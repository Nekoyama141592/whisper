// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'mute_user.g.dart';

@JsonSerializable()
class MuteUser {
  MuteUser({
    required this.activeUid,
    required this.createdAt,
    required this.ipv6,
    required this.uid
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String ipv6;
  final String tokenType = muteUserTokenType;
  final String uid;

  factory MuteUser.fromJson(Map<String,dynamic> json) => _$MuteUserFromJson(json);

  Map<String,dynamic> toJson() => _$MuteUserToJson(this);
}