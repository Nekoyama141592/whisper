// material
import 'package:flutter/material.dart';

class ToggleIcon extends StatelessWidget {

  const ToggleIcon({
    Key? key,
    required this.iconData,
    required this.color,
    required this.toggleTheme
  }) : super(key: key);

  final IconData iconData;
  final Color color;
  final void Function()? toggleTheme;
  @override 
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleTheme,
      child: Icon(
        iconData,
        color: color,
        size: 60,
      ),
    );
  }
}