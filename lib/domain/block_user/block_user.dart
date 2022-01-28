// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'block_user.g.dart';

@JsonSerializable()
class BlockUser {
  BlockUser({
    required this.createdAt,
    required this.ipv6,
    required this.uid
  });
  
  final dynamic createdAt;
  final String ipv6;
  final String tokenType = blockUserTokenType;
  final String uid;

  factory BlockUser.fromJson(Map<String,dynamic> json) => _$BlockUserFromJson(json);

  Map<String,dynamic> toJson() => _$BlockUserToJson(this);
}