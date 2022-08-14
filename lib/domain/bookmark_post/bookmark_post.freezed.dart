// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bookmark_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BookmarkPost _$BookmarkPostFromJson(Map<String, dynamic> json) {
  return _BookmarkPost.fromJson(json);
}

/// @nodoc
mixin _$BookmarkPost {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get passiveUid => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get bookmarkPostCategoryId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookmarkPostCopyWith<BookmarkPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkPostCopyWith<$Res> {
  factory $BookmarkPostCopyWith(
          BookmarkPost value, $Res Function(BookmarkPost) then) =
      _$BookmarkPostCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String passiveUid,
      String postId,
      String tokenId,
      String tokenType,
      String bookmarkPostCategoryId});
}

/// @nodoc
class _$BookmarkPostCopyWithImpl<$Res> implements $BookmarkPostCopyWith<$Res> {
  _$BookmarkPostCopyWithImpl(this._value, this._then);

  final BookmarkPost _value;
  // ignore: unused_field
  final $Res Function(BookmarkPost) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? passiveUid = freezed,
    Object? postId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? bookmarkPostCategoryId = freezed,
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
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      bookmarkPostCategoryId: bookmarkPostCategoryId == freezed
          ? _value.bookmarkPostCategoryId
          : bookmarkPostCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_BookmarkPostCopyWith<$Res>
    implements $BookmarkPostCopyWith<$Res> {
  factory _$$_BookmarkPostCopyWith(
          _$_BookmarkPost value, $Res Function(_$_BookmarkPost) then) =
      __$$_BookmarkPostCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String passiveUid,
      String postId,
      String tokenId,
      String tokenType,
      String bookmarkPostCategoryId});
}

/// @nodoc
class __$$_BookmarkPostCopyWithImpl<$Res>
    extends _$BookmarkPostCopyWithImpl<$Res>
    implements _$$_BookmarkPostCopyWith<$Res> {
  __$$_BookmarkPostCopyWithImpl(
      _$_BookmarkPost _value, $Res Function(_$_BookmarkPost) _then)
      : super(_value, (v) => _then(v as _$_BookmarkPost));

  @override
  _$_BookmarkPost get _value => super._value as _$_BookmarkPost;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? passiveUid = freezed,
    Object? postId = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? bookmarkPostCategoryId = freezed,
  }) {
    return _then(_$_BookmarkPost(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      passiveUid: passiveUid == freezed
          ? _value.passiveUid
          : passiveUid // ignore: cast_nullable_to_non_nullable
              as String,
      postId: postId == freezed
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      bookmarkPostCategoryId: bookmarkPostCategoryId == freezed
          ? _value.bookmarkPostCategoryId
          : bookmarkPostCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BookmarkPost implements _BookmarkPost {
  const _$_BookmarkPost(
      {required this.activeUid,
      required this.createdAt,
      required this.passiveUid,
      required this.postId,
      required this.tokenId,
      required this.tokenType,
      required this.bookmarkPostCategoryId});

  factory _$_BookmarkPost.fromJson(Map<String, dynamic> json) =>
      _$$_BookmarkPostFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String passiveUid;
  @override
  final String postId;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final String bookmarkPostCategoryId;

  @override
  String toString() {
    return 'BookmarkPost(activeUid: $activeUid, createdAt: $createdAt, passiveUid: $passiveUid, postId: $postId, tokenId: $tokenId, tokenType: $tokenType, bookmarkPostCategoryId: $bookmarkPostCategoryId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BookmarkPost &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.passiveUid, passiveUid) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType) &&
            const DeepCollectionEquality()
                .equals(other.bookmarkPostCategoryId, bookmarkPostCategoryId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(passiveUid),
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(bookmarkPostCategoryId));

  @JsonKey(ignore: true)
  @override
  _$$_BookmarkPostCopyWith<_$_BookmarkPost> get copyWith =>
      __$$_BookmarkPostCopyWithImpl<_$_BookmarkPost>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookmarkPostToJson(
      this,
    );
  }
}

abstract class _BookmarkPost implements BookmarkPost {
  const factory _BookmarkPost(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String passiveUid,
      required final String postId,
      required final String tokenId,
      required final String tokenType,
      required final String bookmarkPostCategoryId}) = _$_BookmarkPost;

  factory _BookmarkPost.fromJson(Map<String, dynamic> json) =
      _$_BookmarkPost.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get passiveUid;
  @override
  String get postId;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  String get bookmarkPostCategoryId;
  @override
  @JsonKey(ignore: true)
  _$$_BookmarkPostCopyWith<_$_BookmarkPost> get copyWith =>
      throw _privateConstructorUsedError;
}
