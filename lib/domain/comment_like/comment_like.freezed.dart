// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'comment_like.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) {
  return _CommentLike.fromJson(json);
}

/// @nodoc
mixin _$CommentLike {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentCreatorUid => throw _privateConstructorUsedError;
  dynamic get postCommentDocRef => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get postCommentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentLikeCopyWith<CommentLike> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentLikeCopyWith<$Res> {
  factory $CommentLikeCopyWith(
          CommentLike value, $Res Function(CommentLike) then) =
      _$CommentLikeCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentCreatorUid,
      dynamic postCommentDocRef,
      String postId,
      String postCommentId});
}

/// @nodoc
class _$CommentLikeCopyWithImpl<$Res> implements $CommentLikeCopyWith<$Res> {
  _$CommentLikeCopyWithImpl(this._value, this._then);

  final CommentLike _value;
  // ignore: unused_field
  final $Res Function(CommentLike) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentCreatorUid = freezed,
    Object? postCommentDocRef = freezed,
    Object? postId = freezed,
    Object? postCommentId = freezed,
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
      postCommentCreatorUid: postCommentCreatorUid == freezed
          ? _value.postCommentCreatorUid
          : postCommentCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentDocRef: postCommentDocRef == freezed
          ? _value.postCommentDocRef
          : postCommentDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_CommentLikeCopyWith<$Res>
    implements $CommentLikeCopyWith<$Res> {
  factory _$$_CommentLikeCopyWith(
          _$_CommentLike value, $Res Function(_$_CommentLike) then) =
      __$$_CommentLikeCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentCreatorUid,
      dynamic postCommentDocRef,
      String postId,
      String postCommentId});
}

/// @nodoc
class __$$_CommentLikeCopyWithImpl<$Res> extends _$CommentLikeCopyWithImpl<$Res>
    implements _$$_CommentLikeCopyWith<$Res> {
  __$$_CommentLikeCopyWithImpl(
      _$_CommentLike _value, $Res Function(_$_CommentLike) _then)
      : super(_value, (v) => _then(v as _$_CommentLike));

  @override
  _$_CommentLike get _value => super._value as _$_CommentLike;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentCreatorUid = freezed,
    Object? postCommentDocRef = freezed,
    Object? postId = freezed,
    Object? postCommentId = freezed,
  }) {
    return _then(_$_CommentLike(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentCreatorUid: postCommentCreatorUid == freezed
          ? _value.postCommentCreatorUid
          : postCommentCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentDocRef: postCommentDocRef == freezed
          ? _value.postCommentDocRef
          : postCommentDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CommentLike implements _CommentLike {
  const _$_CommentLike(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentCreatorUid,
      required this.postCommentDocRef,
      required this.postId,
      required this.postCommentId});

  factory _$_CommentLike.fromJson(Map<String, dynamic> json) =>
      _$$_CommentLikeFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCommentCreatorUid;
  @override
  final dynamic postCommentDocRef;
  @override
  final String postId;
  @override
  final String postCommentId;

  @override
  String toString() {
    return 'CommentLike(activeUid: $activeUid, createdAt: $createdAt, postCommentCreatorUid: $postCommentCreatorUid, postCommentDocRef: $postCommentDocRef, postId: $postId, postCommentId: $postCommentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentLike &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCommentCreatorUid, postCommentCreatorUid) &&
            const DeepCollectionEquality()
                .equals(other.postCommentDocRef, postCommentDocRef) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
            const DeepCollectionEquality()
                .equals(other.postCommentId, postCommentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCommentCreatorUid),
      const DeepCollectionEquality().hash(postCommentDocRef),
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(postCommentId));

  @JsonKey(ignore: true)
  @override
  _$$_CommentLikeCopyWith<_$_CommentLike> get copyWith =>
      __$$_CommentLikeCopyWithImpl<_$_CommentLike>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentLikeToJson(
      this,
    );
  }
}

abstract class _CommentLike implements CommentLike {
  const factory _CommentLike(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentCreatorUid,
      required final dynamic postCommentDocRef,
      required final String postId,
      required final String postCommentId}) = _$_CommentLike;

  factory _CommentLike.fromJson(Map<String, dynamic> json) =
      _$_CommentLike.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCommentCreatorUid;
  @override
  dynamic get postCommentDocRef;
  @override
  String get postId;
  @override
  String get postCommentId;
  @override
  @JsonKey(ignore: true)
  _$$_CommentLikeCopyWith<_$_CommentLike> get copyWith =>
      throw _privateConstructorUsedError;
}
