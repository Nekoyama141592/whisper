// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_many_update_user.g.dart';

@JsonSerializable()
class WhisperManyUpdateUser {
  WhisperManyUpdateUser({
    required this.userName,
    required this.uid
  });
  final String userName;
  final String uid;
  factory WhisperManyUpdateUser.fromJson(Map<String,dynamic> json) => _$WhisperManyUpdateUserFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperManyUpdateUserToJson(this);
}