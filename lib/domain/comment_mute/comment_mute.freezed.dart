// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'comment_mute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CommentMute _$CommentMuteFromJson(Map<String, dynamic> json) {
  return _CommentMute.fromJson(json);
}

/// @nodoc
mixin _$CommentMute {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentCreatorUid => throw _privateConstructorUsedError;
  dynamic get postCommentDocRef => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get postCommentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentMuteCopyWith<CommentMute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentMuteCopyWith<$Res> {
  factory $CommentMuteCopyWith(
          CommentMute value, $Res Function(CommentMute) then) =
      _$CommentMuteCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentCreatorUid,
      dynamic postCommentDocRef,
      String postId,
      String postCommentId});
}

/// @nodoc
class _$CommentMuteCopyWithImpl<$Res> implements $CommentMuteCopyWith<$Res> {
  _$CommentMuteCopyWithImpl(this._value, this._then);

  final CommentMute _value;
  // ignore: unused_field
  final $Res Function(CommentMute) _then;

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
abstract class _$$_CommentMuteCopyWith<$Res>
    implements $CommentMuteCopyWith<$Res> {
  factory _$$_CommentMuteCopyWith(
          _$_CommentMute value, $Res Function(_$_CommentMute) then) =
      __$$_CommentMuteCopyWithImpl<$Res>;
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
class __$$_CommentMuteCopyWithImpl<$Res> extends _$CommentMuteCopyWithImpl<$Res>
    implements _$$_CommentMuteCopyWith<$Res> {
  __$$_CommentMuteCopyWithImpl(
      _$_CommentMute _value, $Res Function(_$_CommentMute) _then)
      : super(_value, (v) => _then(v as _$_CommentMute));

  @override
  _$_CommentMute get _value => super._value as _$_CommentMute;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentCreatorUid = freezed,
    Object? postCommentDocRef = freezed,
    Object? postId = freezed,
    Object? postCommentId = freezed,
  }) {
    return _then(_$_CommentMute(
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
class _$_CommentMute implements _CommentMute {
  const _$_CommentMute(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentCreatorUid,
      required this.postCommentDocRef,
      required this.postId,
      required this.postCommentId});

  factory _$_CommentMute.fromJson(Map<String, dynamic> json) =>
      _$$_CommentMuteFromJson(json);

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
    return 'CommentMute(activeUid: $activeUid, createdAt: $createdAt, postCommentCreatorUid: $postCommentCreatorUid, postCommentDocRef: $postCommentDocRef, postId: $postId, postCommentId: $postCommentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CommentMute &&
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
  _$$_CommentMuteCopyWith<_$_CommentMute> get copyWith =>
      __$$_CommentMuteCopyWithImpl<_$_CommentMute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentMuteToJson(
      this,
    );
  }
}

abstract class _CommentMute implements CommentMute {
  const factory _CommentMute(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentCreatorUid,
      required final dynamic postCommentDocRef,
      required final String postId,
      required final String postCommentId}) = _$_CommentMute;

  factory _CommentMute.fromJson(Map<String, dynamic> json) =
      _$_CommentMute.fromJson;

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
  _$$_CommentMuteCopyWith<_$_CommentMute> get copyWith =>
      throw _privateConstructorUsedError;
}
