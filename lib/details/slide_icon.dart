// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisper/constants/doubles.dart';

class SlideIcon extends StatelessWidget {

  const SlideIcon({
    Key? key,
    required this.caption,
    required this.iconData,
    required this.onTap
  }) : super(key: key);

  final String caption;
  final IconData iconData;
  final void Function()? onTap;

  @override 
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(defaultPadding(context: context)))
      ),
      child: IconSlideAction(
        caption: caption,
        icon: iconData,
        color: Theme.of(context).highlightColor,
        onTap: onTap,
      ),
    );
  }
}