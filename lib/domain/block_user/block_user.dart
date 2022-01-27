// packages
import 'package:freezed_annotation/freezed_annotation.dart';

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
  final String uid;

  factory BlockUser.fromJson(Map<String,dynamic> json) => _$BlocksIpv6AndUidFromJson(json);

  Map<String,dynamic> toJson() => _$BlocksIpv6AndUidToJson(this);
}