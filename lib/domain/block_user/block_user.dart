import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_user.freezed.dart';
part 'block_user.g.dart';

@freezed
abstract class BlockUser with _$BlockUser {
 const factory BlockUser({
  required String activeUid,
  required dynamic createdAt,
  required String tokenId,
  required String tokenType,
  required String passiveUid,
  }) = _BlockUser;
 factory BlockUser.fromJson(Map<String, dynamic> json) => _$BlockUserFromJson(json);
}