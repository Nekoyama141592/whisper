// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower.g.dart';

@JsonSerializable()
class Follower{
  Follower({
    required this.followerUid,
    required this.myUid,
    required this.createdAt,
  });
  final String followerUid;
  final dynamic createdAt;
  final String myUid;
  
  factory Follower.fromJson(Map<String,dynamic> json) => _$FollowerFromJson(json);

  Map<String,dynamic> toJson() => _$FollowerToJson(this);
}