import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'follow_notification_model.dart';
import 'package:whisper/parts/notifications/components/follow_notification/components/follow_notification_list.dart';
class FollowNotification extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _followNotificationProvider = watch(followNotificationProvider);
    return !_followNotificationProvider.isLoading ?
    FollowNotificationList(
      _followNotificationProvider.notifications
    )
    : Text('Loading');
  }
}