// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'official_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OfficialNotification _$OfficialNotificationFromJson(Map<String, dynamic> json) {
  return _Timeline.fromJson(json);
}

/// @nodoc
mixin _$OfficialNotification {
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get notificationId => throw _privateConstructorUsedError;
  String get notificationType => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OfficialNotificationCopyWith<OfficialNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfficialNotificationCopyWith<$Res> {
  factory $OfficialNotificationCopyWith(OfficialNotification value,
          $Res Function(OfficialNotification) then) =
      _$OfficialNotificationCopyWithImpl<$Res>;
  $Res call(
      {dynamic createdAt,
      String notificationId,
      String notificationType,
      String text});
}

/// @nodoc
class _$OfficialNotificationCopyWithImpl<$Res>
    implements $OfficialNotificationCopyWith<$Res> {
  _$OfficialNotificationCopyWithImpl(this._value, this._then);

  final OfficialNotification _value;
  // ignore: unused_field
  final $Res Function(OfficialNotification) _then;

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
abstract class _$$_TimelineCopyWith<$Res>
    implements $OfficialNotificationCopyWith<$Res> {
  factory _$$_TimelineCopyWith(
          _$_Timeline value, $Res Function(_$_Timeline) then) =
      __$$_TimelineCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic createdAt,
      String notificationId,
      String notificationType,
      String text});
}

/// @nodoc
class __$$_TimelineCopyWithImpl<$Res>
    extends _$OfficialNotificationCopyWithImpl<$Res>
    implements _$$_TimelineCopyWith<$Res> {
  __$$_TimelineCopyWithImpl(
      _$_Timeline _value, $Res Function(_$_Timeline) _then)
      : super(_value, (v) => _then(v as _$_Timeline));

  @override
  _$_Timeline get _value => super._value as _$_Timeline;

  @override
  $Res call({
    Object? createdAt = freezed,
    Object? notificationId = freezed,
    Object? notificationType = freezed,
    Object? text = freezed,
  }) {
    return _then(_$_Timeline(
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
class _$_Timeline implements _Timeline {
  const _$_Timeline(
      {required this.createdAt,
      required this.notificationId,
      required this.notificationType,
      required this.text});

  factory _$_Timeline.fromJson(Map<String, dynamic> json) =>
      _$$_TimelineFromJson(json);

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
    return 'OfficialNotification(createdAt: $createdAt, notificationId: $notificationId, notificationType: $notificationType, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Timeline &&
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
  _$$_TimelineCopyWith<_$_Timeline> get copyWith =>
      __$$_TimelineCopyWithImpl<_$_Timeline>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TimelineToJson(
      this,
    );
  }
}

abstract class _Timeline implements OfficialNotification {
  const factory _Timeline(
      {required final dynamic createdAt,
      required final String notificationId,
      required final String notificationType,
      required final String text}) = _$_Timeline;

  factory _Timeline.fromJson(Map<String, dynamic> json) = _$_Timeline.fromJson;

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
  _$$_TimelineCopyWith<_$_Timeline> get copyWith =>
      throw _privateConstructorUsedError;
}
