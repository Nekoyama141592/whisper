// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'like_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LikePost _$LikePostFromJson(Map<String, dynamic> json) {
  return _LikePost.fromJson(json);
}

/// @nodoc
mixin _$LikePost {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get passiveUid => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikePostCopyWith<LikePost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikePostCopyWith<$Res> {
  factory $LikePostCopyWith(LikePost value, $Res Function(LikePost) then) =
      _$LikePostCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String passiveUid,
      String postId,
      String tokenId,
      String tokenType});
}

/// @nodoc
class _$LikePostCopyWithImpl<$Res> implements $LikePostCopyWith<$Res> {
  _$LikePostCopyWithImpl(this._value, this._then);

  final LikePost _value;
  // ignore: unused_field
  final $Res Function(LikePost) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? passiveUid = freezed,
    Object? postId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
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
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
abstract class _$$_LikePostCopyWith<$Res> implements $LikePostCopyWith<$Res> {
  factory _$$_LikePostCopyWith(
          _$_LikePost value, $Res Function(_$_LikePost) then) =
      __$$_LikePostCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String passiveUid,
      String postId,
      String tokenId,
      String tokenType});
}

/// @nodoc
class __$$_LikePostCopyWithImpl<$Res> extends _$LikePostCopyWithImpl<$Res>
    implements _$$_LikePostCopyWith<$Res> {
  __$$_LikePostCopyWithImpl(
      _$_LikePost _value, $Res Function(_$_LikePost) _then)
      : super(_value, (v) => _then(v as _$_LikePost));

  @override
  _$_LikePost get _value => super._value as _$_LikePost;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? passiveUid = freezed,
    Object? postId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
  }) {
    return _then(_$_LikePost(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikePost implements _LikePost {
  const _$_LikePost(
      {required this.activeUid,
      required this.createdAt,
      required this.passiveUid,
      required this.postId,
      required this.tokenId,
      required this.tokenType});

  factory _$_LikePost.fromJson(Map<String, dynamic> json) =>
      _$$_LikePostFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String passiveUid;
  @override
  final String postId;
  @override
  final String tokenId;
  @override
  final String tokenType;

  @override
  String toString() {
    return 'LikePost(activeUid: $activeUid, createdAt: $createdAt, passiveUid: $passiveUid, postId: $postId, tokenId: $tokenId, tokenType: $tokenType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikePost &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.passiveUid, passiveUid) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(passiveUid),
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType));

  @JsonKey(ignore: true)
  @override
  _$$_LikePostCopyWith<_$_LikePost> get copyWith =>
      __$$_LikePostCopyWithImpl<_$_LikePost>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikePostToJson(
      this,
    );
  }
}

abstract class _LikePost implements LikePost {
  const factory _LikePost(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String passiveUid,
      required final String postId,
      required final String tokenId,
      required final String tokenType}) = _$_LikePost;

  factory _LikePost.fromJson(Map<String, dynamic> json) = _$_LikePost.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get passiveUid;
  @override
  String get postId;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  @JsonKey(ignore: true)
  _$$_LikePostCopyWith<_$_LikePost> get copyWith =>
      throw _privateConstructorUsedError;
}
