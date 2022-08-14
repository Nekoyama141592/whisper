// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mute_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MuteUser _$MuteUserFromJson(Map<String, dynamic> json) {
  return _MuteUser.fromJson(json);
}

/// @nodoc
mixin _$MuteUser {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get passiveUid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MuteUserCopyWith<MuteUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MuteUserCopyWith<$Res> {
  factory $MuteUserCopyWith(MuteUser value, $Res Function(MuteUser) then) =
      _$MuteUserCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class _$MuteUserCopyWithImpl<$Res> implements $MuteUserCopyWith<$Res> {
  _$MuteUserCopyWithImpl(this._value, this._then);

  final MuteUser _value;
  // ignore: unused_field
  final $Res Function(MuteUser) _then;

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
abstract class _$$_MuteUserCopyWith<$Res> implements $MuteUserCopyWith<$Res> {
  factory _$$_MuteUserCopyWith(
          _$_MuteUser value, $Res Function(_$_MuteUser) then) =
      __$$_MuteUserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class __$$_MuteUserCopyWithImpl<$Res> extends _$MuteUserCopyWithImpl<$Res>
    implements _$$_MuteUserCopyWith<$Res> {
  __$$_MuteUserCopyWithImpl(
      _$_MuteUser _value, $Res Function(_$_MuteUser) _then)
      : super(_value, (v) => _then(v as _$_MuteUser));

  @override
  _$_MuteUser get _value => super._value as _$_MuteUser;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? passiveUid = freezed,
  }) {
    return _then(_$_MuteUser(
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
class _$_MuteUser implements _MuteUser {
  const _$_MuteUser(
      {required this.activeUid,
      required this.createdAt,
      required this.tokenId,
      required this.tokenType,
      required this.passiveUid});

  factory _$_MuteUser.fromJson(Map<String, dynamic> json) =>
      _$$_MuteUserFromJson(json);

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
    return 'MuteUser(activeUid: $activeUid, createdAt: $createdAt, tokenId: $tokenId, tokenType: $tokenType, passiveUid: $passiveUid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MuteUser &&
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
  _$$_MuteUserCopyWith<_$_MuteUser> get copyWith =>
      __$$_MuteUserCopyWithImpl<_$_MuteUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MuteUserToJson(
      this,
    );
  }
}

abstract class _MuteUser implements MuteUser {
  const factory _MuteUser(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String tokenId,
      required final String tokenType,
      required final String passiveUid}) = _$_MuteUser;

  factory _MuteUser.fromJson(Map<String, dynamic> json) = _$_MuteUser.fromJson;

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
  _$$_MuteUserCopyWith<_$_MuteUser> get copyWith =>
      throw _privateConstructorUsedError;
}
