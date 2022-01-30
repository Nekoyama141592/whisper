// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_image.g.dart';

@JsonSerializable()
class WhisperImage {
  WhisperImage({
    required this.description,
    required this.imageURL,
    required this.label,
    required this.storageImageName
  });
  String description;
  String imageURL;
  String label;
  String storageImageName;

  factory WhisperImage.fromJson(Map<String,dynamic> json) => _$WhisperImageFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperImageToJson(this);
}