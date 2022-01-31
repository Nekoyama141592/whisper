// packages
import 'package:freezed_annotation/freezed_annotation.dart';
// constants
import 'package:whisper/constants/strings.dart';

part 'following.g.dart';

@JsonSerializable()
class Following{
  Following({
    required this.myUid,
    required this.createdAt,
    required this.passiveUid,
    required this.tokenId
  });
  final dynamic createdAt;
  final String myUid;
  final String passiveUid;
  final String tokenId;
  final String tokenType = followingTokenType;
  
  factory Following.fromJson(Map<String,dynamic> json) => _$FollowingFromJson(json);

  Map<String,dynamic> toJson() => _$FollowingToJson(this);
}