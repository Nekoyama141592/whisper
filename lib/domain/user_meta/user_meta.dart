import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_meta.freezed.dart';
part 'user_meta.g.dart';

@freezed
abstract class UserMeta with _$UserMeta {
 const factory UserMeta({
    required dynamic createdAt,
    required String email,
    required String gender,
    required String ipv6,
    required num totalAsset,
    required String uid,
    required dynamic updatedAt,
  }) = _UserMeta;
 factory UserMeta.fromJson(Map<String, dynamic> json) => _$UserMetaFromJson(json);
}