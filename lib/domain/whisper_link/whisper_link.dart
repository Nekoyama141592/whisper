// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_link.g.dart';

@JsonSerializable()
class WhisperLink {
  WhisperLink({
    required this.description,
    required this.imageURL,
    required this.label,
    required this.link,
  });
  String description;
  String imageURL;
  String label;
  String link;

  factory WhisperLink.fromJson(Map<String,dynamic> json) => _$WhisperLinkFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperLinkToJson(this);
}