import 'package:freezed_annotation/freezed_annotation.dart';

part 'following.freezed.dart';
part 'following.g.dart';

@freezed
abstract class Following with _$Following {
 const factory Following({
    required dynamic createdAt,
    required String myUid,
    required String passiveUid,
    required String tokenId,
    required String tokenType,
  }) = _Following;
 factory Following.fromJson(Map<String, dynamic> json) => _$FollowingFromJson(json);
}