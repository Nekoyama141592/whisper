// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_update_log_no_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserUpdateLogNoBatch _$UserUpdateLogNoBatchFromJson(Map<String, dynamic> json) {
  return _UserUpdateLogNoBatch.fromJson(json);
}

/// @nodoc
mixin _$UserUpdateLogNoBatch {
  String get bio => throw _privateConstructorUsedError;
  String get dmState => throw _privateConstructorUsedError;
  bool get isKeyAccount => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get links => throw _privateConstructorUsedError;
  dynamic get updatedAt => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get walletAddresses =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserUpdateLogNoBatchCopyWith<UserUpdateLogNoBatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserUpdateLogNoBatchCopyWith<$Res> {
  factory $UserUpdateLogNoBatchCopyWith(UserUpdateLogNoBatch value,
          $Res Function(UserUpdateLogNoBatch) then) =
      _$UserUpdateLogNoBatchCopyWithImpl<$Res>;
  $Res call(
      {String bio,
      String dmState,
      bool isKeyAccount,
      List<Map<String, dynamic>> links,
      dynamic updatedAt,
      String uid,
      List<Map<String, dynamic>> walletAddresses});
}

/// @nodoc
class _$UserUpdateLogNoBatchCopyWithImpl<$Res>
    implements $UserUpdateLogNoBatchCopyWith<$Res> {
  _$UserUpdateLogNoBatchCopyWithImpl(this._value, this._then);

  final UserUpdateLogNoBatch _value;
  // ignore: unused_field
  final $Res Function(UserUpdateLogNoBatch) _then;

  @override
  $Res call({
    Object? bio = freezed,
    Object? dmState = freezed,
    Object? isKeyAccount = freezed,
    Object? links = freezed,
    Object? updatedAt = freezed,
    Object? uid = freezed,
    Object? walletAddresses = freezed,
  }) {
    return _then(_value.copyWith(
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      dmState: dmState == freezed
          ? _value.dmState
          : dmState // ignore: cast_nullable_to_non_nullable
              as String,
      isKeyAccount: isKeyAccount == freezed
          ? _value.isKeyAccount
          : isKeyAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      links: links == freezed
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      walletAddresses: walletAddresses == freezed
          ? _value.walletAddresses
          : walletAddresses // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
abstract class _$$_UserUpdateLogNoBatchCopyWith<$Res>
    implements $UserUpdateLogNoBatchCopyWith<$Res> {
  factory _$$_UserUpdateLogNoBatchCopyWith(_$_UserUpdateLogNoBatch value,
          $Res Function(_$_UserUpdateLogNoBatch) then) =
      __$$_UserUpdateLogNoBatchCopyWithImpl<$Res>;
  @override
  $Res call(
      {String bio,
      String dmState,
      bool isKeyAccount,
      List<Map<String, dynamic>> links,
      dynamic updatedAt,
      String uid,
      List<Map<String, dynamic>> walletAddresses});
}

/// @nodoc
class __$$_UserUpdateLogNoBatchCopyWithImpl<$Res>
    extends _$UserUpdateLogNoBatchCopyWithImpl<$Res>
    implements _$$_UserUpdateLogNoBatchCopyWith<$Res> {
  __$$_UserUpdateLogNoBatchCopyWithImpl(_$_UserUpdateLogNoBatch _value,
      $Res Function(_$_UserUpdateLogNoBatch) _then)
      : super(_value, (v) => _then(v as _$_UserUpdateLogNoBatch));

  @override
  _$_UserUpdateLogNoBatch get _value => super._value as _$_UserUpdateLogNoBatch;

  @override
  $Res call({
    Object? bio = freezed,
    Object? dmState = freezed,
    Object? isKeyAccount = freezed,
    Object? links = freezed,
    Object? updatedAt = freezed,
    Object? uid = freezed,
    Object? walletAddresses = freezed,
  }) {
    return _then(_$_UserUpdateLogNoBatch(
      bio: bio == freezed
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      dmState: dmState == freezed
          ? _value.dmState
          : dmState // ignore: cast_nullable_to_non_nullable
              as String,
      isKeyAccount: isKeyAccount == freezed
          ? _value.isKeyAccount
          : isKeyAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      links: links == freezed
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      updatedAt: updatedAt == freezed
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      walletAddresses: walletAddresses == freezed
          ? _value._walletAddresses
          : walletAddresses // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserUpdateLogNoBatch implements _UserUpdateLogNoBatch {
  const _$_UserUpdateLogNoBatch(
      {required this.bio,
      required this.dmState,
      required this.isKeyAccount,
      required final List<Map<String, dynamic>> links,
      required this.updatedAt,
      required this.uid,
      required final List<Map<String, dynamic>> walletAddresses})
      : _links = links,
        _walletAddresses = walletAddresses;

  factory _$_UserUpdateLogNoBatch.fromJson(Map<String, dynamic> json) =>
      _$$_UserUpdateLogNoBatchFromJson(json);

  @override
  final String bio;
  @override
  final String dmState;
  @override
  final bool isKeyAccount;
  final List<Map<String, dynamic>> _links;
  @override
  List<Map<String, dynamic>> get links {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @override
  final dynamic updatedAt;
  @override
  final String uid;
  final List<Map<String, dynamic>> _walletAddresses;
  @override
  List<Map<String, dynamic>> get walletAddresses {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_walletAddresses);
  }

  @override
  String toString() {
    return 'UserUpdateLogNoBatch(bio: $bio, dmState: $dmState, isKeyAccount: $isKeyAccount, links: $links, updatedAt: $updatedAt, uid: $uid, walletAddresses: $walletAddresses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserUpdateLogNoBatch &&
            const DeepCollectionEquality().equals(other.bio, bio) &&
            const DeepCollectionEquality().equals(other.dmState, dmState) &&
            const DeepCollectionEquality()
                .equals(other.isKeyAccount, isKeyAccount) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality()
                .equals(other._walletAddresses, _walletAddresses));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bio),
      const DeepCollectionEquality().hash(dmState),
      const DeepCollectionEquality().hash(isKeyAccount),
      const DeepCollectionEquality().hash(_links),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(_walletAddresses));

  @JsonKey(ignore: true)
  @override
  _$$_UserUpdateLogNoBatchCopyWith<_$_UserUpdateLogNoBatch> get copyWith =>
      __$$_UserUpdateLogNoBatchCopyWithImpl<_$_UserUpdateLogNoBatch>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserUpdateLogNoBatchToJson(
      this,
    );
  }
}

abstract class _UserUpdateLogNoBatch implements UserUpdateLogNoBatch {
  const factory _UserUpdateLogNoBatch(
          {required final String bio,
          required final String dmState,
          required final bool isKeyAccount,
          required final List<Map<String, dynamic>> links,
          required final dynamic updatedAt,
          required final String uid,
          required final List<Map<String, dynamic>> walletAddresses}) =
      _$_UserUpdateLogNoBatch;

  factory _UserUpdateLogNoBatch.fromJson(Map<String, dynamic> json) =
      _$_UserUpdateLogNoBatch.fromJson;

  @override
  String get bio;
  @override
  String get dmState;
  @override
  bool get isKeyAccount;
  @override
  List<Map<String, dynamic>> get links;
  @override
  dynamic get updatedAt;
  @override
  String get uid;
  @override
  List<Map<String, dynamic>> get walletAddresses;
  @override
  @JsonKey(ignore: true)
  _$$_UserUpdateLogNoBatchCopyWith<_$_UserUpdateLogNoBatch> get copyWith =>
      throw _privateConstructorUsedError;
}
