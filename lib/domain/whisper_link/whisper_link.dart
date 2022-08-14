// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_link.g.dart';
// これはfreezedにしなくて良い
@JsonSerializable()
class WhisperLink {
  WhisperLink({
    required this.description,
    required this.imageURL,
    required this.label,
    required this.url,
  });
  String description, imageURL, label, url;

  factory WhisperLink.fromJson(Map<String,dynamic> json) => _$WhisperLinkFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperLinkToJson(this);
}