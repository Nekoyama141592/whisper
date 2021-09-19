import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'like_notification_model.dart';

import 'package:whisper/parts/notifications/components/like_notification/components/like_notification_list.dart';

class LikeNotification extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _postNotificationProvider = watch(postNotificationProvider);
    return !_postNotificationProvider.isLoading ?
    LikeNotificationList(
      _postNotificationProvider.notifications
    )
    : Text('Loading');
  }
}