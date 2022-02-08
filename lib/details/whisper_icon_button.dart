// material
import 'package:flutter/material.dart';

class WhisperIconButton extends StatelessWidget {

  const WhisperIconButton({
    Key? key,
    required this.icon,
    required this.onTap
  }) : super(key: key);

  final Widget icon;
  final void Function()? onTap;

  @override 
  Widget build(BuildContext context) {
    return InkWell(
      child: icon,
      onTap: onTap,
    );
  }
}