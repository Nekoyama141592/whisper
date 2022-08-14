// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Timeline _$TimelineFromJson(Map<String, dynamic> json) {
  return _Timeline.fromJson(json);
}

/// @nodoc
mixin _$Timeline {
  dynamic get createdAt =>
      throw _privateConstructorUsedError; // フォロワーが投稿を読んだかどうか
  bool get isRead => throw _privateConstructorUsedError;
  String get postCreatorUid => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimelineCopyWith<Timeline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineCopyWith<$Res> {
  factory $TimelineCopyWith(Timeline value, $Res Function(Timeline) then) =
      _$TimelineCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt, bool isRead, String postCreatorUid, String postId});
}

/// @nodoc
class _$TimelineCopyWithImpl<$Res> implements $TimelineCopyWith<$Res> {
  _$TimelineCopyWithImpl(this._value, this._then);

  final Timeline _value;
  // ignore: unused_field
  final $Res Function(Timeline) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? isRead = freezed,
    Object? postCreatorUid = freezed,
    Object? postId = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRead: isRead == freezed
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TimelineCopyWith<$Res> implements $TimelineCopyWith<$Res> {
  factory _$$_TimelineCopyWith(
          _$_Timeline value, $Res Function(_$_Timeline) then) =
      __$$_TimelineCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt, bool isRead, String postCreatorUid, String postId});
}

/// @nodoc
class __$$_TimelineCopyWithImpl<$Res> extends _$TimelineCopyWithImpl<$Res>
    implements _$$_TimelineCopyWith<$Res> {
  __$$_TimelineCopyWithImpl(
      _$_Timeline _value, $Res Function(_$_Timeline) _then)
      : super(_value, (v) => _then(v as _$_Timeline));

  @override
  _$_Timeline get _value => super._value as _$_Timeline;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? isRead = freezed,
    Object? postCreatorUid = freezed,
    Object? postId = freezed,
  }) {
    return _then(_$_Timeline(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isRead: isRead == freezed
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Timeline implements _Timeline {
  const _$_Timeline(
      {required this.createdAt,
      required this.isRead,
      required this.postCreatorUid,
      required this.postId});

  factory _$_Timeline.fromJson(Map<String, dynamic> json) =>
      _$$_TimelineFromJson(json);

  @override
  final dynamic createdAt;
// フォロワーが投稿を読んだかどうか
  @override
  final bool isRead;
  @override
  final String postCreatorUid;
  @override
  final String postId;

  @override
  String toString() {
    return 'Timeline(createdAt: $createdAt, isRead: $isRead, postCreatorUid: $postCreatorUid, postId: $postId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Timeline &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.isRead, isRead) &&
            const DeepCollectionEquality()
                .equals(other.postCreatorUid, postCreatorUid) &&
            const DeepCollectionEquality().equals(other.postId, postId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(isRead),
      const DeepCollectionEquality().hash(postCreatorUid),
      const DeepCollectionEquality().hash(postId));

  @JsonKey(ignore: true)
  @override
  _$$_TimelineCopyWith<_$_Timeline> get copyWith =>
      __$$_TimelineCopyWithImpl<_$_Timeline>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TimelineToJson(
      this,
    );
  }
}

abstract class _Timeline implements Timeline {
  const factory _Timeline(
      {required final dynamic createdAt,
      required final bool isRead,
      required final String postCreatorUid,
      required final String postId}) = _$_Timeline;

  factory _Timeline.fromJson(Map<String, dynamic> json) = _$_Timeline.fromJson;

  @override
  dynamic get createdAt;
  @override // フォロワーが投稿を読んだかどうか
  bool get isRead;
  @override
  String get postCreatorUid;
  @override
  String get postId;
  @override
  @JsonKey(ignore: true)
  _$$_TimelineCopyWith<_$_Timeline> get copyWith =>
      throw _privateConstructorUsedError;
}
