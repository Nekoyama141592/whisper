// flutter
import 'package:flutter/material.dart';
// packages
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:whisper/details/nothing.dart';

class RefreshScreen extends StatelessWidget {
  const RefreshScreen({
    Key? key,
    required this.onRefresh,
    required this.onReload,
    required this.onLoading,
    required this.isEmpty,
    required this.controller,
    required this.subWidget,
    required this.child,
  }) : super(key: key);
  final void Function()? onRefresh;
  final void Function()? onReload;
  final void Function()? onLoading;
  final bool isEmpty;
  final RefreshController controller;
  final Widget subWidget;
  final Widget child;
  @override 
  Widget build(BuildContext context) {
    return isEmpty ?
    Nothing(reload: onReload) :
    Column(
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(),
            onRefresh: onRefresh,
            onLoading: onLoading,
            controller: controller,
            child: child,
          )
        ),
        subWidget
      ],
    );
  }
}