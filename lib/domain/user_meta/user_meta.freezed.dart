// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) {
  return _UserMeta.fromJson(json);
}

/// @nodoc
mixin _$UserMeta {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get ipv6 => throw _privateConstructorUsedError;
  num get totalAsset => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserMetaCopyWith<UserMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMetaCopyWith<$Res> {
  factory $UserMetaCopyWith(UserMeta value, $Res Function(UserMeta) then) =
      _$UserMetaCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      String email,
      String gender,
      String ipv6,
      num totalAsset,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class _$UserMetaCopyWithImpl<$Res> implements $UserMetaCopyWith<$Res> {
  _$UserMetaCopyWithImpl(this._value, this._then);

  final UserMeta _value;
  // ignore: unused_field
  final $Res Function(UserMeta) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? email = freezed,
    Object? gender = freezed,
    Object? ipv6 = freezed,
    Object? totalAsset = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
      totalAsset: totalAsset == freezed
          ? _value.totalAsset
          : totalAsset // ignore: cast_nullable_to_non_nullable
              as num,
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
abstract class _$$_UserMetaCopyWith<$Res> implements $UserMetaCopyWith<$Res> {
  factory _$$_UserMetaCopyWith(
          _$_UserMeta value, $Res Function(_$_UserMeta) then) =
      __$$_UserMetaCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      String email,
      String gender,
      String ipv6,
      num totalAsset,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class __$$_UserMetaCopyWithImpl<$Res> extends _$UserMetaCopyWithImpl<$Res>
    implements _$$_UserMetaCopyWith<$Res> {
  __$$_UserMetaCopyWithImpl(
      _$_UserMeta _value, $Res Function(_$_UserMeta) _then)
      : super(_value, (v) => _then(v as _$_UserMeta));

  @override
  _$_UserMeta get _value => super._value as _$_UserMeta;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? email = freezed,
    Object? gender = freezed,
    Object? ipv6 = freezed,
    Object? totalAsset = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$_UserMeta(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
      totalAsset: totalAsset == freezed
          ? _value.totalAsset
          : totalAsset // ignore: cast_nullable_to_non_nullable
              as num,
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
class _$_UserMeta implements _UserMeta {
  const _$_UserMeta(
      {required this.createdAt,
      required this.email,
      required this.gender,
      required this.ipv6,
      required this.totalAsset,
      required this.uid,
      required this.updatedAt});

  factory _$_UserMeta.fromJson(Map<String, dynamic> json) =>
      _$$_UserMetaFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final String email;
  @override
  final String gender;
  @override
  final String ipv6;
  @override
  final num totalAsset;
  @override
  final String uid;
  @override
  final dynamic updatedAt;

  @override
  String toString() {
    return 'UserMeta(createdAt: $createdAt, email: $email, gender: $gender, ipv6: $ipv6, totalAsset: $totalAsset, uid: $uid, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserMeta &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.gender, gender) &&
            const DeepCollectionEquality().equals(other.ipv6, ipv6) &&
            const DeepCollectionEquality()
                .equals(other.totalAsset, totalAsset) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(gender),
      const DeepCollectionEquality().hash(ipv6),
      const DeepCollectionEquality().hash(totalAsset),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$$_UserMetaCopyWith<_$_UserMeta> get copyWith =>
      __$$_UserMetaCopyWithImpl<_$_UserMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserMetaToJson(
      this,
    );
  }
}

abstract class _UserMeta implements UserMeta {
  const factory _UserMeta(
      {required final dynamic createdAt,
      required final String email,
      required final String gender,
      required final String ipv6,
      required final num totalAsset,
      required final String uid,
      required final dynamic updatedAt}) = _$_UserMeta;

  factory _UserMeta.fromJson(Map<String, dynamic> json) = _$_UserMeta.fromJson;

  @override
  dynamic get createdAt;
  @override
  String get email;
  @override
  String get gender;
  @override
  String get ipv6;
  @override
  num get totalAsset;
  @override
  String get uid;
  @override
  dynamic get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserMetaCopyWith<_$_UserMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
