// material
import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {

  const ToggleIcon({
    Key? key,
    required this.iconData,
    required this.color
  }) : super(key: key);

  final IconData iconData;
  final Color color;
  @override 
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: 60,
    );
  }
}