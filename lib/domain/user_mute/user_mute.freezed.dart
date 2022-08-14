// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_mute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserMute _$UserMuteFromJson(Map<String, dynamic> json) {
  return _UserMute.fromJson(json);
}

/// @nodoc
mixin _$UserMute {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get mutedUid => throw _privateConstructorUsedError;
  String get muterUid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMuteCopyWith<UserMute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMuteCopyWith<$Res> {
  factory $UserMuteCopyWith(UserMute value, $Res Function(UserMute) then) =
      _$UserMuteCopyWithImpl<$Res>;
  $Res call({dynamic createdAt, String mutedUid, String muterUid});
}

/// @nodoc
class _$UserMuteCopyWithImpl<$Res> implements $UserMuteCopyWith<$Res> {
  _$UserMuteCopyWithImpl(this._value, this._then);

  final UserMute _value;
  // ignore: unused_field
  final $Res Function(UserMute) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? mutedUid = freezed,
    Object? muterUid = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mutedUid: mutedUid == freezed
          ? _value.mutedUid
          : mutedUid // ignore: cast_nullable_to_non_nullable
              as String,
      muterUid: muterUid == freezed
          ? _value.muterUid
          : muterUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_UserMuteCopyWith<$Res> implements $UserMuteCopyWith<$Res> {
  factory _$$_UserMuteCopyWith(
          _$_UserMute value, $Res Function(_$_UserMute) then) =
      __$$_UserMuteCopyWithImpl<$Res>;
  @override
  $Res call({dynamic createdAt, String mutedUid, String muterUid});
}

/// @nodoc
class __$$_UserMuteCopyWithImpl<$Res> extends _$UserMuteCopyWithImpl<$Res>
    implements _$$_UserMuteCopyWith<$Res> {
  __$$_UserMuteCopyWithImpl(
      _$_UserMute _value, $Res Function(_$_UserMute) _then)
      : super(_value, (v) => _then(v as _$_UserMute));

  @override
  _$_UserMute get _value => super._value as _$_UserMute;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? mutedUid = freezed,
    Object? muterUid = freezed,
  }) {
    return _then(_$_UserMute(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mutedUid: mutedUid == freezed
          ? _value.mutedUid
          : mutedUid // ignore: cast_nullable_to_non_nullable
              as String,
      muterUid: muterUid == freezed
          ? _value.muterUid
          : muterUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserMute implements _UserMute {
  const _$_UserMute(
      {required this.createdAt,
      required this.mutedUid,
      required this.muterUid});

  factory _$_UserMute.fromJson(Map<String, dynamic> json) =>
      _$$_UserMuteFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final String mutedUid;
  @override
  final String muterUid;

  @override
  String toString() {
    return 'UserMute(createdAt: $createdAt, mutedUid: $mutedUid, muterUid: $muterUid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserMute &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.mutedUid, mutedUid) &&
            const DeepCollectionEquality().equals(other.muterUid, muterUid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(mutedUid),
      const DeepCollectionEquality().hash(muterUid));

  @JsonKey(ignore: true)
  @override
  _$$_UserMuteCopyWith<_$_UserMute> get copyWith =>
      __$$_UserMuteCopyWithImpl<_$_UserMute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserMuteToJson(
      this,
    );
  }
}

abstract class _UserMute implements UserMute {
  const factory _UserMute(
      {required final dynamic createdAt,
      required final String mutedUid,
      required final String muterUid}) = _$_UserMute;

  factory _UserMute.fromJson(Map<String, dynamic> json) = _$_UserMute.fromJson;

  @override
  dynamic get createdAt;
  @override
  String get mutedUid;
  @override
  String get muterUid;
  @override
  @JsonKey(ignore: true)
  _$$_UserMuteCopyWith<_$_UserMute> get copyWith =>
      throw _privateConstructorUsedError;
}
