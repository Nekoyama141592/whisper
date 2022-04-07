// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower.g.dart';

@JsonSerializable()
class Follower{
  Follower({
    required this.followerUid,
    required this.followedUid,
    required this.createdAt,
  });
  final dynamic createdAt;
  final String followedUid;
  final String followerUid;
  
  factory Follower.fromJson(Map<String,dynamic> json) => _$FollowerFromJson(json);

  Map<String,dynamic> toJson() => _$FollowerToJson(this);
}