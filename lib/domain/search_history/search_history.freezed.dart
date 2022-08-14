// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'search_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) {
  return _SearchHistory.fromJson(json);
}

/// @nodoc
mixin _$SearchHistory {
  String get activeUid => throw _privateConstructorUsedError;
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get searchTerm => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get tokenType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchHistoryCopyWith<SearchHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryCopyWith<$Res> {
  factory $SearchHistoryCopyWith(
          SearchHistory value, $Res Function(SearchHistory) then) =
      _$SearchHistoryCopyWithImpl<$Res>;
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String searchTerm,
      String tokenId,
      String tokenType});
}

/// @nodoc
class _$SearchHistoryCopyWithImpl<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  _$SearchHistoryCopyWithImpl(this._value, this._then);

  final SearchHistory _value;
  // ignore: unused_field
  final $Res Function(SearchHistory) _then;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? searchTerm = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
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
      searchTerm: searchTerm == freezed
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_SearchHistoryCopyWith<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  factory _$$_SearchHistoryCopyWith(
          _$_SearchHistory value, $Res Function(_$_SearchHistory) then) =
      __$$_SearchHistoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String activeUid,
      dynamic createdAt,
      String searchTerm,
      String tokenId,
      String tokenType});
}

/// @nodoc
class __$$_SearchHistoryCopyWithImpl<$Res>
    extends _$SearchHistoryCopyWithImpl<$Res>
    implements _$$_SearchHistoryCopyWith<$Res> {
  __$$_SearchHistoryCopyWithImpl(
      _$_SearchHistory _value, $Res Function(_$_SearchHistory) _then)
      : super(_value, (v) => _then(v as _$_SearchHistory));

  @override
  _$_SearchHistory get _value => super._value as _$_SearchHistory;

  @override
  $Res call({
    Object? activeUid = freezed,
    Object? createdAt = freezed,
    Object? searchTerm = freezed,
    Object? tokenId = freezed,
    Object? tokenType = freezed,
  }) {
    return _then(_$_SearchHistory(
      activeUid: activeUid == freezed
          ? _value.activeUid
          : activeUid // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      searchTerm: searchTerm == freezed
          ? _value.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String,
      tokenId: tokenId == freezed
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: tokenType == freezed
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SearchHistory implements _SearchHistory {
  const _$_SearchHistory(
      {required this.activeUid,
      required this.createdAt,
      required this.searchTerm,
      required this.tokenId,
      required this.tokenType});

  factory _$_SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$$_SearchHistoryFromJson(json);

  @override
  final String activeUid;
  @override
  final dynamic createdAt;
  @override
  final String searchTerm;
  @override
  final String tokenId;
  @override
  final String tokenType;

  @override
  String toString() {
    return 'SearchHistory(activeUid: $activeUid, createdAt: $createdAt, searchTerm: $searchTerm, tokenId: $tokenId, tokenType: $tokenType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchHistory &&
            const DeepCollectionEquality().equals(other.activeUid, activeUid) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.searchTerm, searchTerm) &&
            const DeepCollectionEquality().equals(other.tokenId, tokenId) &&
            const DeepCollectionEquality().equals(other.tokenType, tokenType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(activeUid),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(searchTerm),
      const DeepCollectionEquality().hash(tokenId),
      const DeepCollectionEquality().hash(tokenType));

  @JsonKey(ignore: true)
  @override
  _$$_SearchHistoryCopyWith<_$_SearchHistory> get copyWith =>
      __$$_SearchHistoryCopyWithImpl<_$_SearchHistory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SearchHistoryToJson(
      this,
    );
  }
}

abstract class _SearchHistory implements SearchHistory {
  const factory _SearchHistory(
      {required final String activeUid,
      required final dynamic createdAt,
      required final String searchTerm,
      required final String tokenId,
      required final String tokenType}) = _$_SearchHistory;

  factory _SearchHistory.fromJson(Map<String, dynamic> json) =
      _$_SearchHistory.fromJson;

  @override
  String get activeUid;
  @override
  dynamic get createdAt;
  @override
  String get searchTerm;
  @override
  String get tokenId;
  @override
  String get tokenType;
  @override
  @JsonKey(ignore: true)
  _$$_SearchHistoryCopyWith<_$_SearchHistory> get copyWith =>
      throw _privateConstructorUsedError;
}
