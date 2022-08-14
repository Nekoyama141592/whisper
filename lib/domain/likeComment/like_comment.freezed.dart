// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'like_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LikeComment _$LikeCommentFromJson(Map<String, dynamic> json) {
  return _LikeComment.fromJson(json);
}

/// @nodoc
mixin _$LikeComment {
  String get activeUid => throw _privateConstructorUsedError;
  String get postCommentId => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  dynamic get postCommentDocRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikeCommentCopyWith<LikeComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeCommentCopyWith<$Res> {
  factory $LikeCommentCopyWith(
          LikeComment value, $Res Function(LikeComment) then) =
      _$LikeCommentCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      String postCommentId,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      dynamic postCommentDocRef});
}

/// @nodoc
class _$LikeCommentCopyWithImpl<$Res> implements $LikeCommentCopyWith<$Res> {
  _$LikeCommentCopyWithImpl(this._value, this._then);

  final LikeComment _value;
  // ignore: unused_field
  final $Res Function(LikeComment) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? postCommentId = freezed,
    Object? createdAt = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentDocRef = freezed,
  }) {
    return _then(_value.copyWith(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
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
      postCommentDocRef: postCommentDocRef == freezed
          ? _value.postCommentDocRef
          : postCommentDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_LikeCommentCopyWith<$Res>
    implements $LikeCommentCopyWith<$Res> {
  factory _$$_LikeCommentCopyWith(
          _$_LikeComment value, $Res Function(_$_LikeComment) then) =
      __$$_LikeCommentCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      String postCommentId,
      dynamic createdAt,
      String tokenId,
      String tokenType,
      dynamic postCommentDocRef});
}

/// @nodoc
class __$$_LikeCommentCopyWithImpl<$Res> extends _$LikeCommentCopyWithImpl<$Res>
    implements _$$_LikeCommentCopyWith<$Res> {
  __$$_LikeCommentCopyWithImpl(
      _$_LikeComment _value, $Res Function(_$_LikeComment) _then)
      : super(_value, (v) => _then(v as _$_LikeComment));

  @override
  _$_LikeComment get _value => super._value as _$_LikeComment;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? postCommentId = freezed,
    Object? createdAt = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentDocRef = freezed,
  }) {
    return _then(_$_LikeComment(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
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
      postCommentDocRef: postCommentDocRef == freezed
          ? _value.postCommentDocRef
          : postCommentDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikeComment implements _LikeComment {
  const _$_LikeComment(
      {required this.activeUid,
      required this.postCommentId,
      required this.createdAt,
      required this.tokenId,
      required this.tokenType,
      required this.postCommentDocRef});

  factory _$_LikeComment.fromJson(Map<String, dynamic> json) =>
      _$$_LikeCommentFromJson(json);

  @override
  final String activeUid;
  @override
  final String postCommentId;
  @override
  final dynamic createdAt;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final dynamic postCommentDocRef;

  @override
  String toString() {
    return 'LikeComment(activeUid: $activeUid, postCommentId: $postCommentId, createdAt: $createdAt, tokenId: $tokenId, tokenType: $tokenType, postCommentDocRef: $postCommentDocRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikeComment &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality()
                .equals(other.postCommentId, postCommentId) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType) &&
            const DeepCollectionEquality()
                .equals(other.postCommentDocRef, postCommentDocRef));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(postCommentId),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(postCommentDocRef));

  @JsonKey(ignore: true)
  @override
  _$$_LikeCommentCopyWith<_$_LikeComment> get copyWith =>
      __$$_LikeCommentCopyWithImpl<_$_LikeComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikeCommentToJson(
      this,
    );
  }
}

abstract class _LikeComment implements LikeComment {
  const factory _LikeComment(
      {required final String activeUid,
      required final String postCommentId,
      required final dynamic createdAt,
      required final String tokenId,
      required final String tokenType,
      required final dynamic postCommentDocRef}) = _$_LikeComment;

  factory _LikeComment.fromJson(Map<String, dynamic> json) =
      _$_LikeComment.fromJson;

  @override
  String get activeUid;
  @override
  String get postCommentId;
  @override
  dynamic get createdAt;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  dynamic get postCommentDocRef;
  @override
  @JsonKey(ignore: true)
  _$$_LikeCommentCopyWith<_$_LikeComment> get copyWith =>
      throw _privateConstructorUsedError;
}
