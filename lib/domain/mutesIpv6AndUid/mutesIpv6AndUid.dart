// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutesIpv6AndUid.g.dart';

@JsonSerializable()
class MutesIpv6AndUid {
  MutesIpv6AndUid({
    required this.createdAt,
    required this.ipv6,
    required this.uid
  });
  
  final dynamic createdAt;
  final String ipv6;
  final String uid;

  factory MutesIpv6AndUid.fromJson(Map<String,dynamic> json) => _$MutesIpv6AndUidFromJson(json);

  Map<String,dynamic> toJson() => _$MutesIpv6AndUidToJson(this);
}