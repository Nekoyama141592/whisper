// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'following.g.dart';

@JsonSerializable()
class Following{
  Following({
    required this.myUid,
    required this.createdAt,
    required this.passiveUid,
    required this.tokenId,
    required this.tokenType,
  });
  final dynamic createdAt;
  final String myUid;
  final String passiveUid;
  final String tokenId;
  final String tokenType;
  
  factory Following.fromJson(Map<String,dynamic> json) => _$FollowingFromJson(json);

  Map<String,dynamic> toJson() => _$FollowingToJson(this);
}