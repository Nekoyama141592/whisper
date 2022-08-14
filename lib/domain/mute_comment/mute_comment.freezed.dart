// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mute_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MuteComment _$MuteCommentFromJson(Map<String, dynamic> json) {
  return _MuteComment.fromJson(json);
}

/// @nodoc
mixin _$MuteComment {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  dynamic get postCommentDocRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MuteCommentCopyWith<MuteComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MuteCommentCopyWith<$Res> {
  factory $MuteCommentCopyWith(
          MuteComment value, $Res Function(MuteComment) then) =
      _$MuteCommentCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentId,
      String tokenId,
      String tokenType,
      dynamic postCommentDocRef});
}

/// @nodoc
class _$MuteCommentCopyWithImpl<$Res> implements $MuteCommentCopyWith<$Res> {
  _$MuteCommentCopyWithImpl(this._value, this._then);

  final MuteComment _value;
  // ignore: unused_field
  final $Res Function(MuteComment) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentDocRef = freezed,
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
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$_MuteCommentCopyWith<$Res>
    implements $MuteCommentCopyWith<$Res> {
  factory _$$_MuteCommentCopyWith(
          _$_MuteComment value, $Res Function(_$_MuteComment) then) =
      __$$_MuteCommentCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentId,
      String tokenId,
      String tokenType,
      dynamic postCommentDocRef});
}

/// @nodoc
class __$$_MuteCommentCopyWithImpl<$Res> extends _$MuteCommentCopyWithImpl<$Res>
    implements _$$_MuteCommentCopyWith<$Res> {
  __$$_MuteCommentCopyWithImpl(
      _$_MuteComment _value, $Res Function(_$_MuteComment) _then)
      : super(_value, (v) => _then(v as _$_MuteComment));

  @override
  _$_MuteComment get _value => super._value as _$_MuteComment;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentDocRef = freezed,
  }) {
    return _then(_$_MuteComment(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentId: postCommentId == freezed
          ? _value.postCommentId
          : postCommentId // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$_MuteComment implements _MuteComment {
  const _$_MuteComment(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentId,
      required this.tokenId,
      required this.tokenType,
      required this.postCommentDocRef});

  factory _$_MuteComment.fromJson(Map<String, dynamic> json) =>
      _$$_MuteCommentFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCommentId;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final dynamic postCommentDocRef;

  @override
  String toString() {
    return 'MuteComment(activeUid: $activeUid, createdAt: $createdAt, postCommentId: $postCommentId, tokenId: $tokenId, tokenType: $tokenType, postCommentDocRef: $postCommentDocRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MuteComment &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCommentId, postCommentId) &&
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
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCommentId),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(postCommentDocRef));

  @JsonKey(ignore: true)
  @override
  _$$_MuteCommentCopyWith<_$_MuteComment> get copyWith =>
      __$$_MuteCommentCopyWithImpl<_$_MuteComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MuteCommentToJson(
      this,
    );
  }
}

abstract class _MuteComment implements MuteComment {
  const factory _MuteComment(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentId,
      required final String tokenId,
      required final String tokenType,
      required final dynamic postCommentDocRef}) = _$_MuteComment;

  factory _MuteComment.fromJson(Map<String, dynamic> json) =
      _$_MuteComment.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCommentId;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  dynamic get postCommentDocRef;
  @override
  @JsonKey(ignore: true)
  _$$_MuteCommentCopyWith<_$_MuteComment> get copyWith =>
      throw _privateConstructorUsedError;
}
