// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.createdAt,
    required this.email,
    required this.gender,
    required this.isDelete,
    required this.isSuspended,
    required this.ipv6,
    required this.totalAsset,
    required this.uid,
    required this.updatedAt,
  });

  dynamic createdAt;
  final String email;
  String gender;
  String ipv6;
  bool isDelete;
  final bool isSuspended;
  num totalAsset;
  final String uid;
  dynamic updatedAt;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}