import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower.freezed.dart';
part 'follower.g.dart';

@freezed
abstract class Follower with _$Follower {
 const factory Follower({
   required dynamic createdAt,
  required String followedUid,
  required String followerUid,
  }) = _Follower;
 factory Follower.fromJson(Map<String, dynamic> json) => _$FollowerFromJson(json);
}