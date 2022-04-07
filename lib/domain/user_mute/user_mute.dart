// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_mute.g.dart';

@JsonSerializable()
class UserMute{
  UserMute({
    required this.createdAt,
    required this.muterUid,
    required this.mutedUid,
  });
  final dynamic createdAt;
  final String mutedUid;
  final String muterUid;
  
  factory UserMute.fromJson(Map<String,dynamic> json) => _$UserMuteFromJson(json);

  Map<String,dynamic> toJson() => _$UserMuteToJson(this);
}