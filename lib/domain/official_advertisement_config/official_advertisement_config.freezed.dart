// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'official_advertisement_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OfficialAdvertisementConfig _$OfficialAdvertisementConfigFromJson(
    Map<String, dynamic> json) {
  return _OfficialAdvertisement.fromJson(json);
}

/// @nodoc
mixin _$OfficialAdvertisementConfig {
  dynamic get createdAt => throw _privateConstructorUsedError;
  int get intervalSeconds => throw _privateConstructorUsedError;
  int get timeInSecForIosWeb => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OfficialAdvertisementConfigCopyWith<OfficialAdvertisementConfig>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfficialAdvertisementConfigCopyWith<$Res> {
  factory $OfficialAdvertisementConfigCopyWith(
          OfficialAdvertisementConfig value,
          $Res Function(OfficialAdvertisementConfig) then) =
      _$OfficialAdvertisementConfigCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      int intervalSeconds,
      int timeInSecForIosWeb,
      dynamic updatedAt});
}

/// @nodoc
class _$OfficialAdvertisementConfigCopyWithImpl<$Res>
    implements $OfficialAdvertisementConfigCopyWith<$Res> {
  _$OfficialAdvertisementConfigCopyWithImpl(this._value, this._then);

  final OfficialAdvertisementConfig _value;
  // ignore: unused_field
  final $Res Function(OfficialAdvertisementConfig) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? intervalSeconds = freezed,
    Object? timeInSecForIosWeb = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      intervalSeconds: intervalSeconds == freezed
          ? _value.intervalSeconds
          : intervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      timeInSecForIosWeb: timeInSecForIosWeb == freezed
          ? _value.timeInSecForIosWeb
          : timeInSecForIosWeb // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_OfficialAdvertisementCopyWith<$Res>
    implements $OfficialAdvertisementConfigCopyWith<$Res> {
  factory _$$_OfficialAdvertisementCopyWith(_$_OfficialAdvertisement value,
          $Res Function(_$_OfficialAdvertisement) then) =
      __$$_OfficialAdvertisementCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      int intervalSeconds,
      int timeInSecForIosWeb,
      dynamic updatedAt});
}

/// @nodoc
class __$$_OfficialAdvertisementCopyWithImpl<$Res>
    extends _$OfficialAdvertisementConfigCopyWithImpl<$Res>
    implements _$$_OfficialAdvertisementCopyWith<$Res> {
  __$$_OfficialAdvertisementCopyWithImpl(_$_OfficialAdvertisement _value,
      $Res Function(_$_OfficialAdvertisement) _then)
      : super(_value, (v) => _then(v as _$_OfficialAdvertisement));

  @override
  _$_OfficialAdvertisement get _value =>
      super._value as _$_OfficialAdvertisement;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? intervalSeconds = freezed,
    Object? timeInSecForIosWeb = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$_OfficialAdvertisement(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      intervalSeconds: intervalSeconds == freezed
          ? _value.intervalSeconds
          : intervalSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      timeInSecForIosWeb: timeInSecForIosWeb == freezed
          ? _value.timeInSecForIosWeb
          : timeInSecForIosWeb // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OfficialAdvertisement implements _OfficialAdvertisement {
  const _$_OfficialAdvertisement(
      {required this.createdAt,
      required this.intervalSeconds,
      required this.timeInSecForIosWeb,
      required this.updatedAt});

  factory _$_OfficialAdvertisement.fromJson(Map<String, dynamic> json) =>
      _$$_OfficialAdvertisementFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final int intervalSeconds;
  @override
  final int timeInSecForIosWeb;
  @override
  final dynamic updatedAt;

  @override
  String toString() {
    return 'OfficialAdvertisementConfig(createdAt: $createdAt, intervalSeconds: $intervalSeconds, timeInSecForIosWeb: $timeInSecForIosWeb, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OfficialAdvertisement &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.intervalSeconds, intervalSeconds) &&
            const DeepCollectionEquality()
                .equals(other.timeInSecForIosWeb, timeInSecForIosWeb) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(intervalSeconds),
      const DeepCollectionEquality().hash(timeInSecForIosWeb),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$$_OfficialAdvertisementCopyWith<_$_OfficialAdvertisement> get copyWith =>
      __$$_OfficialAdvertisementCopyWithImpl<_$_OfficialAdvertisement>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OfficialAdvertisementToJson(
      this,
    );
  }
}

abstract class _OfficialAdvertisement implements OfficialAdvertisementConfig {
  const factory _OfficialAdvertisement(
      {required final dynamic createdAt,
      required final int intervalSeconds,
      required final int timeInSecForIosWeb,
      required final dynamic updatedAt}) = _$_OfficialAdvertisement;

  factory _OfficialAdvertisement.fromJson(Map<String, dynamic> json) =
      _$_OfficialAdvertisement.fromJson;

  @override
  dynamic get createdAt;
  @override
  int get intervalSeconds;
  @override
  int get timeInSecForIosWeb;
  @override
  dynamic get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_OfficialAdvertisementCopyWith<_$_OfficialAdvertisement> get copyWith =>
      throw _privateConstructorUsedError;
}
