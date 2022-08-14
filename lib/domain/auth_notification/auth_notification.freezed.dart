// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthNotification _$AuthNotificationFromJson(Map<String, dynamic> json) {
  return _AuthNotification.fromJson(json);
}

/// @nodoc
mixin _$AuthNotification {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get notificationId => throw _privateConstructorUsedError;
  String get notificationType => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthNotificationCopyWith<AuthNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthNotificationCopyWith<$Res> {
  factory $AuthNotificationCopyWith(
          AuthNotification value, $Res Function(AuthNotification) then) =
      _$AuthNotificationCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      String notificationId,
      String notificationType,
      String text});
}

/// @nodoc
class _$AuthNotificationCopyWithImpl<$Res>
    implements $AuthNotificationCopyWith<$Res> {
  _$AuthNotificationCopyWithImpl(this._value, this._then);

  final AuthNotification _value;
  // ignore: unused_field
  final $Res Function(AuthNotification) _then;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? notificationId = freezed,
    Object? notificationType = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      notificationId: notificationId == freezed
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationType: notificationType == freezed
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_AuthNotificationCopyWith<$Res>
    implements $AuthNotificationCopyWith<$Res> {
  factory _$$_AuthNotificationCopyWith(
          _$_AuthNotification value, $Res Function(_$_AuthNotification) then) =
      __$$_AuthNotificationCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      String notificationId,
      String notificationType,
      String text});
}

/// @nodoc
class __$$_AuthNotificationCopyWithImpl<$Res>
    extends _$AuthNotificationCopyWithImpl<$Res>
    implements _$$_AuthNotificationCopyWith<$Res> {
  __$$_AuthNotificationCopyWithImpl(
      _$_AuthNotification _value, $Res Function(_$_AuthNotification) _then)
      : super(_value, (v) => _then(v as _$_AuthNotification));

  @override
  _$_AuthNotification get _value => super._value as _$_AuthNotification;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? notificationId = freezed,
    Object? notificationType = freezed,
    Object? text = freezed,
  }) {
    return _then(_$_AuthNotification(
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      notificationId: notificationId == freezed
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as String,
      notificationType: notificationType == freezed
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AuthNotification implements _AuthNotification {
  const _$_AuthNotification(
      {required this.createdAt,
      required this.notificationId,
      required this.notificationType,
      required this.text});

  factory _$_AuthNotification.fromJson(Map<String, dynamic> json) =>
      _$$_AuthNotificationFromJson(json);

  @override
  final dynamic createdAt;
  @override
  final String notificationId;
  @override
  final String notificationType;
  @override
  final String text;

  @override
  String toString() {
    return 'AuthNotification(createdAt: $createdAt, notificationId: $notificationId, notificationType: $notificationType, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthNotification &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.notificationId, notificationId) &&
            const DeepCollectionEquality()
                .equals(other.notificationType, notificationType) &&
            const DeepCollectionEquality().equals(other.text, text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(notificationId),
      const DeepCollectionEquality().hash(notificationType),
      const DeepCollectionEquality().hash(text));

  @JsonKey(ignore: true)
  @override
  _$$_AuthNotificationCopyWith<_$_AuthNotification> get copyWith =>
      __$$_AuthNotificationCopyWithImpl<_$_AuthNotification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AuthNotificationToJson(
      this,
    );
  }
}

abstract class _AuthNotification implements AuthNotification {
  const factory _AuthNotification(
      {required final dynamic createdAt,
      required final String notificationId,
      required final String notificationType,
      required final String text}) = _$_AuthNotification;

  factory _AuthNotification.fromJson(Map<String, dynamic> json) =
      _$_AuthNotification.fromJson;

  @override
  dynamic get createdAt;
  @override
  String get notificationId;
  @override
  String get notificationType;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$_AuthNotificationCopyWith<_$_AuthNotification> get copyWith =>
      throw _privateConstructorUsedError;
}
