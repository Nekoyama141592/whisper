// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.g.dart';

@JsonSerializable()
class UserMeta {
  UserMeta({
    required this.birthDay,
    required this.createdAt,
    required this.gender,
    required this.isAdmin,
    required this.isDelete,
    required this.language,
    required this.uid,
    required this.updatedAt,
  });

  dynamic birthDay;
  dynamic createdAt;
  String gender;
  bool isAdmin;
  bool isDelete;
  String language;
  final String uid;
  dynamic updatedAt;

  factory UserMeta.fromJson(Map<String,dynamic> json) => _$UserMetaFromJson(json);

  Map<String,dynamic> toJson() => _$UserMetaToJson(this);
}