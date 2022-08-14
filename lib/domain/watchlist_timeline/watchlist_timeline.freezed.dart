// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'watchlist_timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WatchlistTimeline _$WatchlistTimelineFromJson(Map<String, dynamic> json) {
  return _WatchlistTimeline.fromJson(json);
}

/// @nodoc
mixin _$WatchlistTimeline {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get postCreatorUid => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  bool get isDelete => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get watchlistId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WatchlistTimelineCopyWith<WatchlistTimeline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WatchlistTimelineCopyWith<$Res> {
  factory $WatchlistTimelineCopyWith(
          WatchlistTimeline value, $Res Function(WatchlistTimeline) then) =
      _$WatchlistTimelineCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      String postCreatorUid,
      bool isRead,
      bool isDelete,
      String postId,
      String watchlistId});
}

/// @nodoc
class _$WatchlistTimelineCopyWithImpl<$Res>
    implements $WatchlistTimelineCopyWith<$Res> {
  _$WatchlistTimelineCopyWithImpl(this._value, this._then);

  final WatchlistTimeline _value;
  // ignore: unused_field
  final $Res Function(WatchlistTimeline) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? postCreatorUid = freezed,
    Object? isRead = freezed,
    Object? isDelete = freezed,
    Object? postId = freezed,
    Object? watchlistId = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: isRead == freezed
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelete: isDelete == freezed
          ? _value.isDelete
          : isDelete // ignore: cast_nullable_to_non_nullable
              as bool,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      watchlistId: watchlistId == freezed
          ? _value.watchlistId
          : watchlistId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_WatchlistTimelineCopyWith<$Res>
    implements $WatchlistTimelineCopyWith<$Res> {
  factory _$$_WatchlistTimelineCopyWith(_$_WatchlistTimeline value,
          $Res Function(_$_WatchlistTimeline) then) =
      __$$_WatchlistTimelineCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      String postCreatorUid,
      bool isRead,
      bool isDelete,
      String postId,
      String watchlistId});
}

/// @nodoc
class __$$_WatchlistTimelineCopyWithImpl<$Res>
    extends _$WatchlistTimelineCopyWithImpl<$Res>
    implements _$$_WatchlistTimelineCopyWith<$Res> {
  __$$_WatchlistTimelineCopyWithImpl(
      _$_WatchlistTimeline _value, $Res Function(_$_WatchlistTimeline) _then)
      : super(_value, (v) => _then(v as _$_WatchlistTimeline));

  @override
  _$_WatchlistTimeline get _value => super._value as _$_WatchlistTimeline;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? postCreatorUid = freezed,
    Object? isRead = freezed,
    Object? isDelete = freezed,
    Object? postId = freezed,
    Object? watchlistId = freezed,
  }) {
    return _then(_$_WatchlistTimeline(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postCreatorUid: postCreatorUid == freezed
          ? _value.postCreatorUid
          : postCreatorUid // ignore: cast_nullable_to_non_nullable
              as String,
      isRead: isRead == freezed
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      isDelete: isDelete == freezed
          ? _value.isDelete
          : isDelete // ignore: cast_nullable_to_non_nullable
              as bool,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      watchlistId: watchlistId == freezed
          ? _value.watchlistId
          : watchlistId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WatchlistTimeline implements _WatchlistTimeline {
  const _$_WatchlistTimeline(
      {required this.createdAt,
      required this.postCreatorUid,
      required this.isRead,
      required this.isDelete,
      required this.postId,
      required this.watchlistId});

  factory _$_WatchlistTimeline.fromJson(Map<String, dynamic> json) =>
      _$$_WatchlistTimelineFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final String postCreatorUid;
  @override
  final bool isRead;
  @override
  final bool isDelete;
  @override
  final String postId;
  @override
  final String watchlistId;

  @override
  String toString() {
    return 'WatchlistTimeline(createdAt: $createdAt, postCreatorUid: $postCreatorUid, isRead: $isRead, isDelete: $isDelete, postId: $postId, watchlistId: $watchlistId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WatchlistTimeline &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.postCreatorUid, postCreatorUid) &&
            const DeepCollectionEquality().equals(other.isRead, isRead) &&
            const DeepCollectionEquality().equals(other.isDelete, isDelete) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
            const DeepCollectionEquality()
                .equals(other.watchlistId, watchlistId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(postCreatorUid),
      const DeepCollectionEquality().hash(isRead),
      const DeepCollectionEquality().hash(isDelete),
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(watchlistId));

  @JsonKey(ignore: true)
  @override
  _$$_WatchlistTimelineCopyWith<_$_WatchlistTimeline> get copyWith =>
      __$$_WatchlistTimelineCopyWithImpl<_$_WatchlistTimeline>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WatchlistTimelineToJson(
      this,
    );
  }
}

abstract class _WatchlistTimeline implements WatchlistTimeline {
  const factory _WatchlistTimeline(
      {required final dynamic createdAt,
      required final String postCreatorUid,
      required final bool isRead,
      required final bool isDelete,
      required final String postId,
      required final String watchlistId}) = _$_WatchlistTimeline;

  factory _WatchlistTimeline.fromJson(Map<String, dynamic> json) =
      _$_WatchlistTimeline.fromJson;

  @override
  dynamic get createdAt;
  @override
  String get postCreatorUid;
  @override
  bool get isRead;
  @override
  bool get isDelete;
  @override
  String get postId;
  @override
  String get watchlistId;
  @override
  @JsonKey(ignore: true)
  _$$_WatchlistTimelineCopyWith<_$_WatchlistTimeline> get copyWith =>
      throw _privateConstructorUsedError;
}
