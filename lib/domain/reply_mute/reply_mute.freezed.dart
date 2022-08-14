// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'reply_mute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ReplyMute _$ReplyMuteFromJson(Map<String, dynamic> json) {
  return _ReplyMute.fromJson(json);
}

/// @nodoc
mixin _$ReplyMute {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCommentReplyCreatorUid => throw _privateConstructorUsedError;
  String get postCommentReplyId => throw _privateConstructorUsedError;
  dynamic get postCommentReplyDocRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReplyMuteCopyWith<ReplyMute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyMuteCopyWith<$Res> {
  factory $ReplyMuteCopyWith(ReplyMute value, $Res Function(ReplyMute) then) =
      _$ReplyMuteCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyCreatorUid,
      String postCommentReplyId,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class _$ReplyMuteCopyWithImpl<$Res> implements $ReplyMuteCopyWith<$Res> {
  _$ReplyMuteCopyWithImpl(this._value, this._then);

  final ReplyMute _value;
  // ignore: unused_field
  final $Res Function(ReplyMute) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyCreatorUid = freezed,
    Object? postCommentReplyId = freezed,
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
      postCommentReplyCreatorUid: postCommentReplyCreatorUid == freezed
          ? _value.postCommentReplyCreatorUid
          : postCommentReplyCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyId: postCommentReplyId == freezed
          ? _value.postCommentReplyId
          : postCommentReplyId // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyDocRef: postCommentReplyDocRef == freezed
          ? _value.postCommentReplyDocRef
          : postCommentReplyDocRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_ReplyMuteCopyWith<$Res> implements $ReplyMuteCopyWith<$Res> {
  factory _$$_ReplyMuteCopyWith(
          _$_ReplyMute value, $Res Function(_$_ReplyMute) then) =
      __$$_ReplyMuteCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCommentReplyCreatorUid,
      String postCommentReplyId,
      dynamic postCommentReplyDocRef});
}

/// @nodoc
class __$$_ReplyMuteCopyWithImpl<$Res> extends _$ReplyMuteCopyWithImpl<$Res>
    implements _$$_ReplyMuteCopyWith<$Res> {
  __$$_ReplyMuteCopyWithImpl(
      _$_ReplyMute _value, $Res Function(_$_ReplyMute) _then)
      : super(_value, (v) => _then(v as _$_ReplyMute));

  @override
  _$_ReplyMute get _value => super._value as _$_ReplyMute;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCommentReplyCreatorUid = freezed,
    Object? postCommentReplyId = freezed,
    Object? postCommentReplyDocRef = freezed,
  }) {
    return _then(_$_ReplyMute(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCommentReplyCreatorUid: postCommentReplyCreatorUid == freezed
          ? _value.postCommentReplyCreatorUid
          : postCommentReplyCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postCommentReplyId: postCommentReplyId == freezed
          ? _value.postCommentReplyId
          : postCommentReplyId // ignore: cast_nullable_to_non_nullable
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
class _$_ReplyMute implements _ReplyMute {
  const _$_ReplyMute(
      {required this.activeUid,
      required this.createdAt,
      required this.postCommentReplyCreatorUid,
      required this.postCommentReplyId,
      required this.postCommentReplyDocRef});

  factory _$_ReplyMute.fromJson(Map<String, dynamic> json) =>
      _$$_ReplyMuteFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String postCommentReplyCreatorUid;
  @override
  final String postCommentReplyId;
  @override
  final dynamic postCommentReplyDocRef;

  @override
  String toString() {
    return 'ReplyMute(activeUid: $activeUid, createdAt: $createdAt, postCommentReplyCreatorUid: $postCommentReplyCreatorUid, postCommentReplyId: $postCommentReplyId, postCommentReplyDocRef: $postCommentReplyDocRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReplyMute &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(
                other.postCommentReplyCreatorUid, postCommentReplyCreatorUid) &&
            const DeepCollectionEquality()
                .equals(other.postCommentReplyId, postCommentReplyId) &&
            const DeepCollectionEquality()
                .equals(other.postCommentReplyDocRef, postCommentReplyDocRef));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCommentReplyCreatorUid),
      const DeepCollectionEquality().hash(postCommentReplyId),
      const DeepCollectionEquality().hash(postCommentReplyDocRef));

  @JsonKey(ignore: true)
  @override
  _$$_ReplyMuteCopyWith<_$_ReplyMute> get copyWith =>
      __$$_ReplyMuteCopyWithImpl<_$_ReplyMute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReplyMuteToJson(
      this,
    );
  }
}

abstract class _ReplyMute implements ReplyMute {
  const factory _ReplyMute(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCommentReplyCreatorUid,
      required final String postCommentReplyId,
      required final dynamic postCommentReplyDocRef}) = _$_ReplyMute;

  factory _ReplyMute.fromJson(Map<String, dynamic> json) =
      _$_ReplyMute.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get postCommentReplyCreatorUid;
  @override
  String get postCommentReplyId;
  @override
  dynamic get postCommentReplyDocRef;
  @override
  @JsonKey(ignore: true)
  _$$_ReplyMuteCopyWith<_$_ReplyMute> get copyWith =>
      throw _privateConstructorUsedError;
}
