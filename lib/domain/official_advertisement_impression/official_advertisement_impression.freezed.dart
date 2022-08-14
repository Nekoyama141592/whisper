// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'official_advertisement_impression.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OfficialAdvertisementImpression _$OfficialAdvertisementImpressionFromJson(
    Map<String, dynamic> json) {
  return _OfficialAdvertisementImpression.fromJson(json);
}

/// @nodoc
mixin _$OfficialAdvertisementImpression {
  dynamic get createdAt => throw _privateConstructorUsedError;
  bool get isDarkTheme => throw _privateConstructorUsedError;
  String get officialAdvertisementId => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OfficialAdvertisementImpressionCopyWith<OfficialAdvertisementImpression>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfficialAdvertisementImpressionCopyWith<$Res> {
  factory $OfficialAdvertisementImpressionCopyWith(
          OfficialAdvertisementImpression value,
          $Res Function(OfficialAdvertisementImpression) then) =
      _$OfficialAdvertisementImpressionCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      bool isDarkTheme,
      String officialAdvertisementId,
      String uid});
}

/// @nodoc
class _$OfficialAdvertisementImpressionCopyWithImpl<$Res>
    implements $OfficialAdvertisementImpressionCopyWith<$Res> {
  _$OfficialAdvertisementImpressionCopyWithImpl(this._value, this._then);

  final OfficialAdvertisementImpression _value;
  // ignore: unused_field
  final $Res Function(OfficialAdvertisementImpression) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? isDarkTheme = freezed,
    Object? officialAdvertisementId = freezed,
    Object? uid = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isDarkTheme: isDarkTheme == freezed
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      officialAdvertisementId: officialAdvertisementId == freezed
          ? _value.officialAdvertisementId
          : officialAdvertisementId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_OfficialAdvertisementImpressionCopyWith<$Res>
    implements $OfficialAdvertisementImpressionCopyWith<$Res> {
  factory _$$_OfficialAdvertisementImpressionCopyWith(
          _$_OfficialAdvertisementImpression value,
          $Res Function(_$_OfficialAdvertisementImpression) then) =
      __$$_OfficialAdvertisementImpressionCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      bool isDarkTheme,
      String officialAdvertisementId,
      String uid});
}

/// @nodoc
class __$$_OfficialAdvertisementImpressionCopyWithImpl<$Res>
    extends _$OfficialAdvertisementImpressionCopyWithImpl<$Res>
    implements _$$_OfficialAdvertisementImpressionCopyWith<$Res> {
  __$$_OfficialAdvertisementImpressionCopyWithImpl(
      _$_OfficialAdvertisementImpression _value,
      $Res Function(_$_OfficialAdvertisementImpression) _then)
      : super(_value, (v) => _then(v as _$_OfficialAdvertisementImpression));

  @override
  _$_OfficialAdvertisementImpression get _value =>
      super._value as _$_OfficialAdvertisementImpression;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? isDarkTheme = freezed,
    Object? officialAdvertisementId = freezed,
    Object? uid = freezed,
  }) {
    return _then(_$_OfficialAdvertisementImpression(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isDarkTheme: isDarkTheme == freezed
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      officialAdvertisementId: officialAdvertisementId == freezed
          ? _value.officialAdvertisementId
          : officialAdvertisementId // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OfficialAdvertisementImpression
    implements _OfficialAdvertisementImpression {
  const _$_OfficialAdvertisementImpression(
      {required this.createdAt,
      required this.isDarkTheme,
      required this.officialAdvertisementId,
      required this.uid});

  factory _$_OfficialAdvertisementImpression.fromJson(
          Map<String, dynamic> json) =>
      _$$_OfficialAdvertisementImpressionFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final bool isDarkTheme;
  @override
  final String officialAdvertisementId;
  @override
  final String uid;

  @override
  String toString() {
    return 'OfficialAdvertisementImpression(createdAt: $createdAt, isDarkTheme: $isDarkTheme, officialAdvertisementId: $officialAdvertisementId, uid: $uid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OfficialAdvertisementImpression &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.isDarkTheme, isDarkTheme) &&
            const DeepCollectionEquality().equals(
                other.officialAdvertisementId, officialAdvertisementId) &&
            const DeepCollectionEquality().equals(other.uid, uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(isDarkTheme),
      const DeepCollectionEquality().hash(officialAdvertisementId),
      const DeepCollectionEquality().hash(uid));

  @JsonKey(ignore: true)
  @override
  _$$_OfficialAdvertisementImpressionCopyWith<
          _$_OfficialAdvertisementImpression>
      get copyWith => __$$_OfficialAdvertisementImpressionCopyWithImpl<
          _$_OfficialAdvertisementImpression>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OfficialAdvertisementImpressionToJson(
      this,
    );
  }
}

abstract class _OfficialAdvertisementImpression
    implements OfficialAdvertisementImpression {
  const factory _OfficialAdvertisementImpression(
      {required final dynamic createdAt,
      required final bool isDarkTheme,
      required final String officialAdvertisementId,
      required final String uid}) = _$_OfficialAdvertisementImpression;

  factory _OfficialAdvertisementImpression.fromJson(Map<String, dynamic> json) =
      _$_OfficialAdvertisementImpression.fromJson;

  @override
  dynamic get createdAt;
  @override
  bool get isDarkTheme;
  @override
  String get officialAdvertisementId;
  @override
  String get uid;
  @override
  @JsonKey(ignore: true)
  _$$_OfficialAdvertisementImpressionCopyWith<
          _$_OfficialAdvertisementImpression>
      get copyWith => throw _privateConstructorUsedError;
}
