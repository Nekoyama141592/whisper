// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'like_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LikeReply _$LikeReplyFromJson(Map<String, dynamic> json) {
  return _LikeReply.fromJson(json);
}

/// @nodoc
mixin _$LikeReply {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentReplyId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  dynamic get postCommentReplyDocRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LikeReplyCopyWith<LikeReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeReplyCopyWith<$Res> {
  factory $LikeReplyCopyWith(LikeReply value, $Res Function(LikeReply) then) =
      _$LikeReplyCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyId,
      String tokenId,
      String tokenType,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class _$LikeReplyCopyWithImpl<$Res> implements $LikeReplyCopyWith<$Res> {
  _$LikeReplyCopyWithImpl(this._value, this._then);

  final LikeReply _value;
  // ignore: unused_field
  final $Res Function(LikeReply) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentReplyDocRef = freezed,
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
      postCommentReplyId: postCommentReplyId == freezed
          ? _value.postCommentReplyId
          : postCommentReplyId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyDocRef: postCommentReplyDocRef == freezed
          ? _value.postCommentReplyDocRef
          : postCommentReplyDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_LikeReplyCopyWith<$Res> implements $LikeReplyCopyWith<$Res> {
  factory _$$_LikeReplyCopyWith(
          _$_LikeReply value, $Res Function(_$_LikeReply) then) =
      __$$_LikeReplyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyId,
      String tokenId,
      String tokenType,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class __$$_LikeReplyCopyWithImpl<$Res> extends _$LikeReplyCopyWithImpl<$Res>
    implements _$$_LikeReplyCopyWith<$Res> {
  __$$_LikeReplyCopyWithImpl(
      _$_LikeReply _value, $Res Function(_$_LikeReply) _then)
      : super(_value, (v) => _then(v as _$_LikeReply));

  @override
  _$_LikeReply get _value => super._value as _$_LikeReply;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? postCommentReplyDocRef = freezed,
  }) {
    return _then(_$_LikeReply(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentReplyId: postCommentReplyId == freezed
          ? _value.postCommentReplyId
          : postCommentReplyId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyDocRef: postCommentReplyDocRef == freezed
          ? _value.postCommentReplyDocRef
          : postCommentReplyDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LikeReply implements _LikeReply {
  const _$_LikeReply(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentReplyId,
      required this.tokenId,
      required this.tokenType,
      required this.postCommentReplyDocRef});

  factory _$_LikeReply.fromJson(Map<String, dynamic> json) =>
      _$$_LikeReplyFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCommentReplyId;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final dynamic postCommentReplyDocRef;

  @override
  String toString() {
    return 'LikeReply(activeUid: $activeUid, createdAt: $createdAt, postCommentReplyId: $postCommentReplyId, tokenId: $tokenId, tokenType: $tokenType, postCommentReplyDocRef: $postCommentReplyDocRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikeReply &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCommentReplyId, postCommentReplyId) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType) &&
            const DeepCollectionEquality()
                .equals(other.postCommentReplyDocRef, postCommentReplyDocRef));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCommentReplyId),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(postCommentReplyDocRef));

  @JsonKey(ignore: true)
  @override
  _$$_LikeReplyCopyWith<_$_LikeReply> get copyWith =>
      __$$_LikeReplyCopyWithImpl<_$_LikeReply>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LikeReplyToJson(
      this,
    );
  }
}

abstract class _LikeReply implements LikeReply {
  const factory _LikeReply(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentReplyId,
      required final String tokenId,
      required final String tokenType,
      required final dynamic postCommentReplyDocRef}) = _$_LikeReply;

  factory _LikeReply.fromJson(Map<String, dynamic> json) =
      _$_LikeReply.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCommentReplyId;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  dynamic get postCommentReplyDocRef;
  @override
  @JsonKey(ignore: true)
  _$$_LikeReplyCopyWith<_$_LikeReply> get copyWith =>
      throw _privateConstructorUsedError;
}
