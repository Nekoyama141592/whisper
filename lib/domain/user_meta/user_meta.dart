// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.birthDay,
    required this.createdAt,
    required this.gender,
    required this.isDelete,
    required this.isSuspended,
    required this.ipv6,
    required this.language,
    required this.totalAsset,
    required this.uid,
    required this.updatedAt,
  });

  dynamic birthDay;
  dynamic createdAt;
  String gender;
  String ipv6;
  bool isDelete;
  final bool isSuspended;
  String language;
  num totalAsset;
  final String uid;
  dynamic updatedAt;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}