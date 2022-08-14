// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'block_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BlockUser _$BlockUserFromJson(Map<String, dynamic> json) {
  return _BlockUser.fromJson(json);
}

/// @nodoc
mixin _$BlockUser {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get passiveUid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlockUserCopyWith<BlockUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockUserCopyWith<$Res> {
  factory $BlockUserCopyWith(BlockUser value, $Res Function(BlockUser) then) =
      _$BlockUserCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class _$BlockUserCopyWithImpl<$Res> implements $BlockUserCopyWith<$Res> {
  _$BlockUserCopyWithImpl(this._value, this._then);

  final BlockUser _value;
  // ignore: unused_field
  final $Res Function(BlockUser) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? passiveUid = freezed,
  }) {
    return _then(_value.copyWith(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_BlockUserCopyWith<$Res> implements $BlockUserCopyWith<$Res> {
  factory _$$_BlockUserCopyWith(
          _$_BlockUser value, $Res Function(_$_BlockUser) then) =
      __$$_BlockUserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class __$$_BlockUserCopyWithImpl<$Res> extends _$BlockUserCopyWithImpl<$Res>
    implements _$$_BlockUserCopyWith<$Res> {
  __$$_BlockUserCopyWithImpl(
      _$_BlockUser _value, $Res Function(_$_BlockUser) _then)
      : super(_value, (v) => _then(v as _$_BlockUser));

  @override
  _$_BlockUser get _value => super._value as _$_BlockUser;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? passiveUid = freezed,
  }) {
    return _then(_$_BlockUser(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BlockUser implements _BlockUser {
  const _$_BlockUser(
      {required this.activeUid,
      required this.createdAt,
      required this.tokenId,
      required this.tokenType,
      required this.passiveUid});

  factory _$_BlockUser.fromJson(Map<String, dynamic> json) =>
      _$$_BlockUserFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final String passiveUid;

  @override
  String toString() {
    return 'BlockUser(activeUid: $activeUid, createdAt: $createdAt, tokenId: $tokenId, tokenType: $tokenType, passiveUid: $passiveUid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BlockUser &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType) &&
            const DeepCollectionEquality()
                .equals(other.passiveUid, passiveUid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(passiveUid));

  @JsonKey(ignore: true)
  @override
  _$$_BlockUserCopyWith<_$_BlockUser> get copyWith =>
      __$$_BlockUserCopyWithImpl<_$_BlockUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BlockUserToJson(
      this,
    );
  }
}

abstract class _BlockUser implements BlockUser {
  const factory _BlockUser(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String tokenId,
      required final String tokenType,
      required final String passiveUid}) = _$_BlockUser;

  factory _BlockUser.fromJson(Map<String, dynamic> json) =
      _$_BlockUser.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  String get passiveUid;
  @override
  @JsonKey(ignore: true)
  _$$_BlockUserCopyWith<_$_BlockUser> get copyWith =>
      throw _privateConstructorUsedError;
}
