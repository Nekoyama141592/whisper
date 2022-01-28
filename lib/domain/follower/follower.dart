// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower.g.dart';

@JsonSerializable()
class Follower{
  Follower({
    required this.activeUid,
    required this.myUid,
    required this.createdAt,
  });
  final String activeUid;
  final dynamic createdAt;
  final String myUid;
  
  factory Follower.fromJson(Map<String,dynamic> json) => _$FollowerFromJson(json);

  Map<String,dynamic> toJson() => _$FollowerToJson(this);
}