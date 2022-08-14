import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisper_image.freezed.dart';
part 'whisper_image.g.dart';

@freezed
abstract class WhisperImage with _$WhisperImage {
 const factory WhisperImage({
    required String description,
    required String imageURL,
    required String label,
  }) = _WhisperImage;
 factory WhisperImage.fromJson(Map<String, dynamic> json) => _$WhisperImageFromJson(json);
}