// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bookmark_post_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BookmarkPostCategory _$BookmarkPostCategoryFromJson(Map<String, dynamic> json) {
  return _BookmarkPostCategory.fromJson(json);
}

/// @nodoc
mixin _$BookmarkPostCategory {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;
  String get imageURL => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookmarkPostCategoryCopyWith<BookmarkPostCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkPostCategoryCopyWith<$Res> {
  factory $BookmarkPostCategoryCopyWith(BookmarkPostCategory value,
          $Res Function(BookmarkPostCategory) then) =
      _$BookmarkPostCategoryCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      String categoryName,
      String tokenId,
      String tokenType,
      String imageURL,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class _$BookmarkPostCategoryCopyWithImpl<$Res>
    implements $BookmarkPostCategoryCopyWith<$Res> {
  _$BookmarkPostCategoryCopyWithImpl(this._value, this._then);

  final BookmarkPostCategory _value;
  // ignore: unused_field
  final $Res Function(BookmarkPostCategory) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? categoryName = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? imageURL = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
abstract class _$$_BookmarkPostCategoryCopyWith<$Res>
    implements $BookmarkPostCategoryCopyWith<$Res> {
  factory _$$_BookmarkPostCategoryCopyWith(_$_BookmarkPostCategory value,
          $Res Function(_$_BookmarkPostCategory) then) =
      __$$_BookmarkPostCategoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      String categoryName,
      String tokenId,
      String tokenType,
      String imageURL,
      String uid,
      dynamic updatedAt});
}

/// @nodoc
class __$$_BookmarkPostCategoryCopyWithImpl<$Res>
    extends _$BookmarkPostCategoryCopyWithImpl<$Res>
    implements _$$_BookmarkPostCategoryCopyWith<$Res> {
  __$$_BookmarkPostCategoryCopyWithImpl(_$_BookmarkPostCategory _value,
      $Res Function(_$_BookmarkPostCategory) _then)
      : super(_value, (v) => _then(v as _$_BookmarkPostCategory));

  @override
  _$_BookmarkPostCategory get _value => super._value as _$_BookmarkPostCategory;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? categoryName = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
    Object? imageURL = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$_BookmarkPostCategory(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      categoryName: categoryName == freezed
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      imageURL: imageURL == freezed
          ? _value.imageURL
          : imageURL // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BookmarkPostCategory implements _BookmarkPostCategory {
  const _$_BookmarkPostCategory(
      {required this.createdAt,
      required this.categoryName,
      required this.tokenId,
      required this.tokenType,
      required this.imageURL,
      required this.uid,
      required this.updatedAt});

  factory _$_BookmarkPostCategory.fromJson(Map<String, dynamic> json) =>
      _$$_BookmarkPostCategoryFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final String categoryName;
  @override
  final String tokenId;
  @override
  final String tokenType;
  @override
  final String imageURL;
  @override
  final String uid;
  @override
  final dynamic updatedAt;

  @override
  String toString() {
    return 'BookmarkPostCategory(createdAt: $createdAt, categoryName: $categoryName, tokenId: $tokenId, tokenType: $tokenType, imageURL: $imageURL, uid: $uid, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BookmarkPostCategory &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.categoryName, categoryName) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType) &&
            const DeepCollectionEquality().equals(other.imageURL, imageURL) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(categoryName),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType),
      const DeepCollectionEquality().hash(imageURL),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(updatedAt));

  @JsonKey(ignore: true)
  @override
  _$$_BookmarkPostCategoryCopyWith<_$_BookmarkPostCategory> get copyWith =>
      __$$_BookmarkPostCategoryCopyWithImpl<_$_BookmarkPostCategory>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookmarkPostCategoryToJson(
      this,
    );
  }
}

abstract class _BookmarkPostCategory implements BookmarkPostCategory {
  const factory _BookmarkPostCategory(
      {required final dynamic createdAt,
      required final String categoryName,
      required final String tokenId,
      required final String tokenType,
      required final String imageURL,
      required final String uid,
      required final dynamic updatedAt}) = _$_BookmarkPostCategory;

  factory _BookmarkPostCategory.fromJson(Map<String, dynamic> json) =
      _$_BookmarkPostCategory.fromJson;

  @override
  dynamic get createdAt;
  @override
  String get categoryName;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  String get imageURL;
  @override
  String get uid;
  @override
  dynamic get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_BookmarkPostCategoryCopyWith<_$_BookmarkPostCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
