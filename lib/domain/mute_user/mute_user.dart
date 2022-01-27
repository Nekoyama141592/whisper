// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_user.g.dart';

@JsonSerializable()
class MuteUser {
  MuteUser({
    required this.createdAt,
    required this.ipv6,
    required this.uid
  });
  
  final dynamic createdAt;
  final String ipv6;
  final String uid;

  factory MuteUser.fromJson(Map<String,dynamic> json) => _$MutesIpv6AndUidFromJson(json);

  Map<String,dynamic> toJson() => _$MutesIpv6AndUidToJson(this);
}