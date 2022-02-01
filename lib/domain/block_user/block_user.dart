// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'block_user.g.dart';

@JsonSerializable()
class BlockUser {
  BlockUser({
    required this.activeUid,
    required this.createdAt,
    required this.ipv6,
    required this.tokenId,
    required this.passiveUid
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String ipv6;
  final String tokenId;
  final String tokenType = blockUserTokenType;
  final String passiveUid;

  factory BlockUser.fromJson(Map<String,dynamic> json) => _$BlockUserFromJson(json);

  Map<String,dynamic> toJson() => _$BlockUserToJson(this);
}