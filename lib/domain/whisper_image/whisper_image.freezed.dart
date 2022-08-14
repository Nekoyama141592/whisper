// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'whisper_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WhisperImage _$WhisperImageFromJson(Map<String, dynamic> json) {
  return _WhisperImage.fromJson(json);
}

/// @nodoc
mixin _$WhisperImage {
  String get description => throw _privateConstructorUsedError;
  String get imageURL => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WhisperImageCopyWith<WhisperImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WhisperImageCopyWith<$Res> {
  factory $WhisperImageCopyWith(
          WhisperImage value, $Res Function(WhisperImage) then) =
      _$WhisperImageCopyWithImpl<$Res>;
  $Res call({String description, String imageURL, String label});
}

/// @nodoc
class _$WhisperImageCopyWithImpl<$Res> implements $WhisperImageCopyWith<$Res> {
  _$WhisperImageCopyWithImpl(this._value, this._then);

  final WhisperImage _value;
  // ignore: unused_field
  final $Res Function(WhisperImage) _then;

  @override
  $Res call({
    Object? description = freezed,
    Object? imageURL = freezed,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_WhisperImageCopyWith<$Res>
    implements $WhisperImageCopyWith<$Res> {
  factory _$$_WhisperImageCopyWith(
          _$_WhisperImage value, $Res Function(_$_WhisperImage) then) =
      __$$_WhisperImageCopyWithImpl<$Res>;
  @override
  $Res call({String description, String imageURL, String label});
}

/// @nodoc
class __$$_WhisperImageCopyWithImpl<$Res>
    extends _$WhisperImageCopyWithImpl<$Res>
    implements _$$_WhisperImageCopyWith<$Res> {
  __$$_WhisperImageCopyWithImpl(
      _$_WhisperImage _value, $Res Function(_$_WhisperImage) _then)
      : super(_value, (v) => _then(v as _$_WhisperImage));

  @override
  _$_WhisperImage get _value => super._value as _$_WhisperImage;

  @override
  $Res call({
    Object? description = freezed,
    Object? imageURL = freezed,
    Object? label = freezed,
  }) {
    return _then(_$_WhisperImage(
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WhisperImage implements _WhisperImage {
  const _$_WhisperImage(
      {required this.description, required this.imageURL, required this.label});

  factory _$_WhisperImage.fromJson(Map<String, dynamic> json) =>
      _$$_WhisperImageFromJson(json);

  @override
  final String description;
  @override
  final String imageURL;
  @override
  final String label;

  @override
  String toString() {
    return 'WhisperImage(description: $description, imageURL: $imageURL, label: $label)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WhisperImage &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.imageURL, imageURL) &&
            const DeepCollectionEquality().equals(other.label, label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(imageURL),
      const DeepCollectionEquality().hash(label));

  @JsonKey(ignore: true)
  @override
  _$$_WhisperImageCopyWith<_$_WhisperImage> get copyWith =>
      __$$_WhisperImageCopyWithImpl<_$_WhisperImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WhisperImageToJson(
      this,
    );
  }
}

abstract class _WhisperImage implements WhisperImage {
  const factory _WhisperImage(
      {required final String description,
      required final String imageURL,
      required final String label}) = _$_WhisperImage;

  factory _WhisperImage.fromJson(Map<String, dynamic> json) =
      _$_WhisperImage.fromJson;

  @override
  String get description;
  @override
  String get imageURL;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$_WhisperImageCopyWith<_$_WhisperImage> get copyWith =>
      throw _privateConstructorUsedError;
}
