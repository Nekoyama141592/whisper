// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'read_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReadPost _$ReadPostFromJson(Map<String, dynamic> json) {
  return _ReadPost.fromJson(json);
}

/// @nodoc
mixin _$ReadPost {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get passiveUid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReadPostCopyWith<ReadPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadPostCopyWith<$Res> {
  factory $ReadPostCopyWith(ReadPost value, $Res Function(ReadPost) then) =
      _$ReadPostCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postId,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class _$ReadPostCopyWithImpl<$Res> implements $ReadPostCopyWith<$Res> {
  _$ReadPostCopyWithImpl(this._value, this._then);

  final ReadPost _value;
  // ignore: unused_field
  final $Res Function(ReadPost) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postId = freezed,
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
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$_ReadPostCopyWith<$Res> implements $ReadPostCopyWith<$Res> {
  factory _$$_ReadPostCopyWith(
          _$_ReadPost value, $Res Function(_$_ReadPost) then) =
      __$$_ReadPostCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postId,
      String tokenId,
      String tokenType,
      String passiveUid});
}

/// @nodoc
class __$$_ReadPostCopyWithImpl<$Res> extends _$ReadPostCopyWithImpl<$Res>
    implements _$$_ReadPostCopyWith<$Res> {
  __$$_ReadPostCopyWithImpl(
      _$_ReadPost _value, $Res Function(_$_ReadPost) _then)
      : super(_value, (v) => _then(v as _$_ReadPost));

  @override
  _$_ReadPost get _value => super._value as _$_ReadPost;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? passiveUid = freezed,
  }) {
    return _then(_$_ReadPost(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$_ReadPost implements _ReadPost {
  const _$_ReadPost(
      {required this.activeUid,
      required this.createdAt,
      required this.postId,
      required this.tokenId,
      required this.tokenType,
      required this.passiveUid});

  factory _$_ReadPost.fromJson(Map<String, dynamic> json) =>
      _$$_ReadPostFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postId;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final String passiveUid;

  @override
  String toString() {
    return 'ReadPost(activeUid: $activeUid, createdAt: $createdAt, postId: $postId, tokenId: $tokenId, tokenType: $tokenType, passiveUid: $passiveUid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReadPost &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
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
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(passiveUid));

  @JsonKey(ignore: true)
  @override
  _$$_ReadPostCopyWith<_$_ReadPost> get copyWith =>
      __$$_ReadPostCopyWithImpl<_$_ReadPost>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReadPostToJson(
      this,
    );
  }
}

abstract class _ReadPost implements ReadPost {
  const factory _ReadPost(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postId,
      required final String tokenId,
      required final String tokenType,
      required final String passiveUid}) = _$_ReadPost;

  factory _ReadPost.fromJson(Map<String, dynamic> json) = _$_ReadPost.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postId;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  String get passiveUid;
  @override
  @JsonKey(ignore: true)
  _$$_ReadPostCopyWith<_$_ReadPost> get copyWith =>
      throw _privateConstructorUsedError;
}
