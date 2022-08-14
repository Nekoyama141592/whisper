// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mute_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MuteReply _$MuteReplyFromJson(Map<String, dynamic> json) {
  return _MuteReply.fromJson(json);
}

/// @nodoc
mixin _$MuteReply {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentReplyId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  dynamic get postCommentReplyDocRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MuteReplyCopyWith<MuteReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MuteReplyCopyWith<$Res> {
  factory $MuteReplyCopyWith(MuteReply value, $Res Function(MuteReply) then) =
      _$MuteReplyCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyId,
      String tokenType,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class _$MuteReplyCopyWithImpl<$Res> implements $MuteReplyCopyWith<$Res> {
  _$MuteReplyCopyWithImpl(this._value, this._then);

  final MuteReply _value;
  // ignore: unused_field
  final $Res Function(MuteReply) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyId = freezed,
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
abstract class _$$_MuteReplyCopyWith<$Res> implements $MuteReplyCopyWith<$Res> {
  factory _$$_MuteReplyCopyWith(
          _$_MuteReply value, $Res Function(_$_MuteReply) then) =
      __$$_MuteReplyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyId,
      String tokenType,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class __$$_MuteReplyCopyWithImpl<$Res> extends _$MuteReplyCopyWithImpl<$Res>
    implements _$$_MuteReplyCopyWith<$Res> {
  __$$_MuteReplyCopyWithImpl(
      _$_MuteReply _value, $Res Function(_$_MuteReply) _then)
      : super(_value, (v) => _then(v as _$_MuteReply));

  @override
  _$_MuteReply get _value => super._value as _$_MuteReply;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyId = freezed,
    Object? tokenType = freezed,
    Object? postCommentReplyDocRef = freezed,
  }) {
    return _then(_$_MuteReply(
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
class _$_MuteReply implements _MuteReply {
  const _$_MuteReply(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentReplyId,
      required this.tokenType,
      required this.postCommentReplyDocRef});

  factory _$_MuteReply.fromJson(Map<String, dynamic> json) =>
      _$$_MuteReplyFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCommentReplyId;
  @override
  final String tokenType;
  @override
  final dynamic postCommentReplyDocRef;

  @override
  String toString() {
    return 'MuteReply(activeUid: $activeUid, createdAt: $createdAt, postCommentReplyId: $postCommentReplyId, tokenType: $tokenType, postCommentReplyDocRef: $postCommentReplyDocRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MuteReply &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCommentReplyId, postCommentReplyId) &&
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
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(postCommentReplyDocRef));

  @JsonKey(ignore: true)
  @override
  _$$_MuteReplyCopyWith<_$_MuteReply> get copyWith =>
      __$$_MuteReplyCopyWithImpl<_$_MuteReply>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MuteReplyToJson(
      this,
    );
  }
}

abstract class _MuteReply implements MuteReply {
  const factory _MuteReply(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentReplyId,
      required final String tokenType,
      required final dynamic postCommentReplyDocRef}) = _$_MuteReply;

  factory _MuteReply.fromJson(Map<String, dynamic> json) =
      _$_MuteReply.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCommentReplyId;
  @override
  String get tokenType;
  @override
  dynamic get postCommentReplyDocRef;
  @override
  @JsonKey(ignore: true)
  _$$_MuteReplyCopyWith<_$_MuteReply> get copyWith =>
      throw _privateConstructorUsedError;
}
