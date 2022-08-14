// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'post_like.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostLike _$PostLikeFromJson(Map<String, dynamic> json) {
  return _PostLike.fromJson(json);
}

/// @nodoc
mixin _$PostLike {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCreatorUid => throw _privateConstructorUsedError;
  dynamic get postDocRef => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostLikeCopyWith<PostLike> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostLikeCopyWith<$Res> {
  factory $PostLikeCopyWith(PostLike value, $Res Function(PostLike) then) =
      _$PostLikeCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCreatorUid,
      dynamic postDocRef,
      String postId});
}

/// @nodoc
class _$PostLikeCopyWithImpl<$Res> implements $PostLikeCopyWith<$Res> {
  _$PostLikeCopyWithImpl(this._value, this._then);

  final PostLike _value;
  // ignore: unused_field
  final $Res Function(PostLike) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCreatorUid = freezed,
    Object? postDocRef = freezed,
    Object? postId = freezed,
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
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postDocRef: postDocRef == freezed
          ? _value.postDocRef
          : postDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_PostLikeCopyWith<$Res> implements $PostLikeCopyWith<$Res> {
  factory _$$_PostLikeCopyWith(
          _$_PostLike value, $Res Function(_$_PostLike) then) =
      __$$_PostLikeCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCreatorUid,
      dynamic postDocRef,
      String postId});
}

/// @nodoc
class __$$_PostLikeCopyWithImpl<$Res> extends _$PostLikeCopyWithImpl<$Res>
    implements _$$_PostLikeCopyWith<$Res> {
  __$$_PostLikeCopyWithImpl(
      _$_PostLike _value, $Res Function(_$_PostLike) _then)
      : super(_value, (v) => _then(v as _$_PostLike));

  @override
  _$_PostLike get _value => super._value as _$_PostLike;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCreatorUid = freezed,
    Object? postDocRef = freezed,
    Object? postId = freezed,
  }) {
    return _then(_$_PostLike(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postDocRef: postDocRef == freezed
          ? _value.postDocRef
          : postDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PostLike implements _PostLike {
  const _$_PostLike(
      {required this.activeUid,
      required this.createdAt,
      required this.postCreatorUid,
      required this.postDocRef,
      required this.postId});

  factory _$_PostLike.fromJson(Map<String, dynamic> json) =>
      _$$_PostLikeFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCreatorUid;
  @override
  final dynamic postDocRef;
  @override
  final String postId;

  @override
  String toString() {
    return 'PostLike(activeUid: $activeUid, createdAt: $createdAt, postCreatorUid: $postCreatorUid, postDocRef: $postDocRef, postId: $postId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostLike &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCreatorUid, postCreatorUid) &&
            const DeepCollectionEquality()
                .equals(other.postDocRef, postDocRef) &&
            const DeepCollectionEquality().equals(other.postId, postId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCreatorUid),
      const DeepCollectionEquality().hash(postDocRef),
      const DeepCollectionEquality().hash(postId));

  @JsonKey(ignore: true)
  @override
  _$$_PostLikeCopyWith<_$_PostLike> get copyWith =>
      __$$_PostLikeCopyWithImpl<_$_PostLike>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostLikeToJson(
      this,
    );
  }
}

abstract class _PostLike implements PostLike {
  const factory _PostLike(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCreatorUid,
      required final dynamic postDocRef,
      required final String postId}) = _$_PostLike;

  factory _PostLike.fromJson(Map<String, dynamic> json) = _$_PostLike.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCreatorUid;
  @override
  dynamic get postDocRef;
  @override
  String get postId;
  @override
  @JsonKey(ignore: true)
  _$$_PostLikeCopyWith<_$_PostLike> get copyWith =>
      throw _privateConstructorUsedError;
}
