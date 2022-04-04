// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.createdAt,
    required this.email,
    required this.gender,
    required this.ipv6,
    required this.totalAsset,
    required this.uid,
    required this.updatedAt,
  });

  final dynamic createdAt;
  final String email;
  String gender;
  final String ipv6;
  final num totalAsset;
  final String uid;
  dynamic updatedAt;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}