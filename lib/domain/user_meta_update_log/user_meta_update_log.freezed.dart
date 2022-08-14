// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_meta_update_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserMetaUpdateLog _$UserMetaUpdateLogFromJson(Map<String, dynamic> json) {
  return _UserMetaUpdateLog.fromJson(json);
}

/// @nodoc
mixin _$UserMetaUpdateLog {
  String get email => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get ipv6 => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMetaUpdateLogCopyWith<UserMetaUpdateLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMetaUpdateLogCopyWith<$Res> {
  factory $UserMetaUpdateLogCopyWith(
          UserMetaUpdateLog value, $Res Function(UserMetaUpdateLog) then) =
      _$UserMetaUpdateLogCopyWithImpl<$Res>;
  $Res call(
      {String email,
      String gender,
      String ipv6,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class _$UserMetaUpdateLogCopyWithImpl<$Res>
    implements $UserMetaUpdateLogCopyWith<$Res> {
  _$UserMetaUpdateLogCopyWithImpl(this._value, this._then);

  final UserMetaUpdateLog _value;
  // ignore: unused_field
  final $Res Function(UserMetaUpdateLog) _then;

  @override
  $Res call({
    Object? email = freezed,
    Object? gender = freezed,
    Object? ipv6 = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      ipv6: ipv6 == freezed
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_UserMetaUpdateLogCopyWith<$Res>
    implements $UserMetaUpdateLogCopyWith<$Res> {
  factory _$$_UserMetaUpdateLogCopyWith(_$_UserMetaUpdateLog value,
          $Res Function(_$_UserMetaUpdateLog) then) =
      __$$_UserMetaUpdateLogCopyWithImpl<$Res>;
  @override
  $Res call(
      {String email,
      String gender,
      String ipv6,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class __$$_UserMetaUpdateLogCopyWithImpl<$Res>
    extends _$UserMetaUpdateLogCopyWithImpl<$Res>
    implements _$$_UserMetaUpdateLogCopyWith<$Res> {
  __$$_UserMetaUpdateLogCopyWithImpl(
      _$_UserMetaUpdateLog _value, $Res Function(_$_UserMetaUpdateLog) _then)
      : super(_value, (v) => _then(v as _$_UserMetaUpdateLog));

  @override
  _$_UserMetaUpdateLog get _value => super._value as _$_UserMetaUpdateLog;

  @override
  $Res call({
    Object? email = freezed,
    Object? gender = freezed,
    Object? ipv6 = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$_UserMetaUpdateLog(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      ipv6: ipv6 == freezed
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserMetaUpdateLog implements _UserMetaUpdateLog {
  const _$_UserMetaUpdateLog(
      {required this.email,
      required this.gender,
      required this.ipv6,
      required this.uid,
      required this.updatedAt});

  factory _$_UserMetaUpdateLog.fromJson(Map<String, dynamic> json) =>
      _$$_UserMetaUpdateLogFromJson(json);

  @override
  final String email;
  @override
  final String gender;
  @override
  final String ipv6;
  @override
  final String uid;
  @override
  final dynamic updatedAt;

  @override
  String toString() {
    return 'UserMetaUpdateLog(email: $email, gender: $gender, ipv6: $ipv6, uid: $uid, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserMetaUpdateLog &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.gender, gender) &&
            const DeepCollectionEquality().equals(other.ipv6, ipv6) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(gender),
      const DeepCollectionEquality().hash(ipv6),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$$_UserMetaUpdateLogCopyWith<_$_UserMetaUpdateLog> get copyWith =>
      __$$_UserMetaUpdateLogCopyWithImpl<_$_UserMetaUpdateLog>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserMetaUpdateLogToJson(
      this,
    );
  }
}

abstract class _UserMetaUpdateLog implements UserMetaUpdateLog {
  const factory _UserMetaUpdateLog(
      {required final String email,
      required final String gender,
      required final String ipv6,
      required final String uid,
      required final dynamic updatedAt}) = _$_UserMetaUpdateLog;

  factory _UserMetaUpdateLog.fromJson(Map<String, dynamic> json) =
      _$_UserMetaUpdateLog.fromJson;

  @override
  String get email;
  @override
  String get gender;
  @override
  String get ipv6;
  @override
  String get uid;
  @override
  dynamic get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserMetaUpdateLogCopyWith<_$_UserMetaUpdateLog> get copyWith =>
      throw _privateConstructorUsedError;
}
