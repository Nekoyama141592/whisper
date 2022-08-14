// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'post_mute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostMute _$PostMuteFromJson(Map<String, dynamic> json) {
  return _PostMute.fromJson(json);
}

/// @nodoc
mixin _$PostMute {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCreatorUid => throw _privateConstructorUsedError;
  dynamic get postDocRef => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostMuteCopyWith<PostMute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostMuteCopyWith<$Res> {
  factory $PostMuteCopyWith(PostMute value, $Res Function(PostMute) then) =
      _$PostMuteCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCreatorUid,
      dynamic postDocRef,
      String postId});
}

/// @nodoc
class _$PostMuteCopyWithImpl<$Res> implements $PostMuteCopyWith<$Res> {
  _$PostMuteCopyWithImpl(this._value, this._then);

  final PostMute _value;
  // ignore: unused_field
  final $Res Function(PostMute) _then;

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
abstract class _$$_PostMuteCopyWith<$Res> implements $PostMuteCopyWith<$Res> {
  factory _$$_PostMuteCopyWith(
          _$_PostMute value, $Res Function(_$_PostMute) then) =
      __$$_PostMuteCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String postCreatorUid,
      dynamic postDocRef,
      String postId});
}

/// @nodoc
class __$$_PostMuteCopyWithImpl<$Res> extends _$PostMuteCopyWithImpl<$Res>
    implements _$$_PostMuteCopyWith<$Res> {
  __$$_PostMuteCopyWithImpl(
      _$_PostMute _value, $Res Function(_$_PostMute) _then)
      : super(_value, (v) => _then(v as _$_PostMute));

  @override
  _$_PostMute get _value => super._value as _$_PostMute;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? postCreatorUid = freezed,
    Object? postDocRef = freezed,
    Object? postId = freezed,
  }) {
    return _then(_$_PostMute(
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
class _$_PostMute implements _PostMute {
  const _$_PostMute(
      {required this.activeUid,
      required this.createdAt,
      required this.postCreatorUid,
      required this.postDocRef,
      required this.postId});

  factory _$_PostMute.fromJson(Map<String, dynamic> json) =>
      _$$_PostMuteFromJson(json);

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
    return 'PostMute(activeUid: $activeUid, createdAt: $createdAt, postCreatorUid: $postCreatorUid, postDocRef: $postDocRef, postId: $postId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostMute &&
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
  _$$_PostMuteCopyWith<_$_PostMute> get copyWith =>
      __$$_PostMuteCopyWithImpl<_$_PostMute>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PostMuteToJson(
      this,
    );
  }
}

abstract class _PostMute implements PostMute {
  const factory _PostMute(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String postCreatorUid,
      required final dynamic postDocRef,
      required final String postId}) = _$_PostMute;

  factory _PostMute.fromJson(Map<String, dynamic> json) = _$_PostMute.fromJson;

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
  _$$_PostMuteCopyWith<_$_PostMute> get copyWith =>
      throw _privateConstructorUsedError;
}
