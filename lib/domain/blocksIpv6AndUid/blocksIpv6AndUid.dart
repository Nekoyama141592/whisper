// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocksIpv6AndUid.g.dart';

@JsonSerializable()
class BlocksIpv6AndUid {
  BlocksIpv6AndUid({
    required this.createdAt,
    required this.ipv6,
    required this.uid
  });
  
  final dynamic createdAt;
  final String ipv6;
  final String uid;

  factory BlocksIpv6AndUid.fromJson(Map<String,dynamic> json) => _$BlocksIpv6AndUidFromJson(json);

  Map<String,dynamic> toJson() => _$BlocksIpv6AndUidToJson(this);
}