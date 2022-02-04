// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_user.g.dart';

@JsonSerializable()
class BlockUser {
  BlockUser({
    required this.activeUid,
    required this.createdAt,
    required this.tokenId,
    required this.tokenType,
    required this.passiveUid
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String tokenId;
  final String tokenType;
  final String passiveUid;

  factory BlockUser.fromJson(Map<String,dynamic> json) => _$BlockUserFromJson(json);

  Map<String,dynamic> toJson() => _$BlockUserToJson(this);
}