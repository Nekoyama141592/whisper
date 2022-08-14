// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_update_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserUpdateLog _$UserUpdateLogFromJson(Map<String, dynamic> json) {
  return _Timeline.fromJson(json);
}

/// @nodoc
mixin _$UserUpdateLog {
  String get accountName => throw _privateConstructorUsedError;
  String get mainWalletAddress => throw _privateConstructorUsedError;
  String get recommendState => throw _privateConstructorUsedError;
  Map<String, dynamic> get searchToken => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userImageURL => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserUpdateLogCopyWith<UserUpdateLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserUpdateLogCopyWith<$Res> {
  factory $UserUpdateLogCopyWith(
          UserUpdateLog value, $Res Function(UserUpdateLog) then) =
      _$UserUpdateLogCopyWithImpl<$Res>;
  $Res call(
      {String accountName,
      String mainWalletAddress,
      String recommendState,
      Map<String, dynamic> searchToken,
      String uid,
      dynamic updatedAt,
      String userName,
      String userImageURL});
}

/// @nodoc
class _$UserUpdateLogCopyWithImpl<$Res>
    implements $UserUpdateLogCopyWith<$Res> {
  _$UserUpdateLogCopyWithImpl(this._value, this._then);

  final UserUpdateLog _value;
  // ignore: unused_field
  final $Res Function(UserUpdateLog) _then;

  @override
  $Res call({
    Object? accountName = freezed,
    Object? mainWalletAddress = freezed,
    Object? recommendState = freezed,
    Object? searchToken = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userImageURL = freezed,
  }) {
    return _then(_value.copyWith(
      accountName: accountName == freezed
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      mainWalletAddress: mainWalletAddress == freezed
          ? _value.mainWalletAddress
          : mainWalletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      recommendState: recommendState == freezed
          ? _value.recommendState
          : recommendState // ignore: cast_nullable_to_non_nullable
              as String,
      searchToken: searchToken == freezed
          ? _value.searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userImageURL: userImageURL == freezed
          ? _value.userImageURL
          : userImageURL // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TimelineCopyWith<$Res>
    implements $UserUpdateLogCopyWith<$Res> {
  factory _$$_TimelineCopyWith(
          _$_Timeline value, $Res Function(_$_Timeline) then) =
      __$$_TimelineCopyWithImpl<$Res>;
  @override
  $Res call(
      {String accountName,
      String mainWalletAddress,
      String recommendState,
      Map<String, dynamic> searchToken,
      String uid,
      dynamic updatedAt,
      String userName,
      String userImageURL});
}

/// @nodoc
class __$$_TimelineCopyWithImpl<$Res> extends _$UserUpdateLogCopyWithImpl<$Res>
    implements _$$_TimelineCopyWith<$Res> {
  __$$_TimelineCopyWithImpl(
      _$_Timeline _value, $Res Function(_$_Timeline) _then)
      : super(_value, (v) => _then(v as _$_Timeline));

  @override
  _$_Timeline get _value => super._value as _$_Timeline;

  @override
  $Res call({
    Object? accountName = freezed,
    Object? mainWalletAddress = freezed,
    Object? recommendState = freezed,
    Object? searchToken = freezed,
    Object? uid = freezed,
    Object? updatedAt = freezed,
    Object? userName = freezed,
    Object? userImageURL = freezed,
  }) {
    return _then(_$_Timeline(
      accountName: accountName == freezed
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      mainWalletAddress: mainWalletAddress == freezed
          ? _value.mainWalletAddress
          : mainWalletAddress // ignore: cast_nullable_to_non_nullable
              as String,
      recommendState: recommendState == freezed
          ? _value.recommendState
          : recommendState // ignore: cast_nullable_to_non_nullable
              as String,
      searchToken: searchToken == freezed
          ? _value._searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userImageURL: userImageURL == freezed
          ? _value.userImageURL
          : userImageURL // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Timeline implements _Timeline {
  const _$_Timeline(
      {required this.accountName,
      required this.mainWalletAddress,
      required this.recommendState,
      required final Map<String, dynamic> searchToken,
      required this.uid,
      required this.updatedAt,
      required this.userName,
      required this.userImageURL})
      : _searchToken = searchToken;

  factory _$_Timeline.fromJson(Map<String, dynamic> json) =>
      _$$_TimelineFromJson(json);

  @override
  final String accountName;
  @override
  final String mainWalletAddress;
  @override
  final String recommendState;
  final Map<String, dynamic> _searchToken;
  @override
  Map<String, dynamic> get searchToken {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_searchToken);
  }

  @override
  final String uid;
  @override
  final dynamic updatedAt;
  @override
  final String userName;
  @override
  final String userImageURL;

  @override
  String toString() {
    return 'UserUpdateLog(accountName: $accountName, mainWalletAddress: $mainWalletAddress, recommendState: $recommendState, searchToken: $searchToken, uid: $uid, updatedAt: $updatedAt, userName: $userName, userImageURL: $userImageURL)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Timeline &&
            const DeepCollectionEquality()
                .equals(other.accountName, accountName) &&
            const DeepCollectionEquality()
                .equals(other.mainWalletAddress, mainWalletAddress) &&
            const DeepCollectionEquality()
                .equals(other.recommendState, recommendState) &&
            const DeepCollectionEquality()
                .equals(other._searchToken, _searchToken) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.userName, userName) &&
            const DeepCollectionEquality()
                .equals(other.userImageURL, userImageURL));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(accountName),
      const DeepCollectionEquality().hash(mainWalletAddress),
      const DeepCollectionEquality().hash(recommendState),
      const DeepCollectionEquality().hash(_searchToken),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(userName),
      const DeepCollectionEquality().hash(userImageURL));

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

abstract class _Timeline implements UserUpdateLog {
  const factory _Timeline(
      {required final String accountName,
      required final String mainWalletAddress,
      required final String recommendState,
      required final Map<String, dynamic> searchToken,
      required final String uid,
      required final dynamic updatedAt,
      required final String userName,
      required final String userImageURL}) = _$_Timeline;

  factory _Timeline.fromJson(Map<String, dynamic> json) = _$_Timeline.fromJson;

  @override
  String get accountName;
  @override
  String get mainWalletAddress;
  @override
  String get recommendState;
  @override
  Map<String, dynamic> get searchToken;
  @override
  String get uid;
  @override
  dynamic get updatedAt;
  @override
  String get userName;
  @override
  String get userImageURL;
  @override
  @JsonKey(ignore: true)
  _$$_TimelineCopyWith<_$_Timeline> get copyWith =>
      throw _privateConstructorUsedError;
}
