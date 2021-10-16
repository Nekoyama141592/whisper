// material
import 'package:flutter/material.dart';

class SpeedControllButton extends StatelessWidget {

  const SpeedControllButton({
    Key? key,
    required this.speedNotifier,
    required this.speedControll
  }) : super(key: key);

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
  @override 
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: speedNotifier, 
      builder: (_,speed,__) {
        return TextButton(
          onPressed: speedControll, 
          child: Text(
            '✖️' + speed.toString(),
            style: TextStyle(
              color: Theme.of(context).focusColor
            ),
          )
        );
      }
    );
  }
}