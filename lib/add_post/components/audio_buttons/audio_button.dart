import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {

  AudioButton(this.description,this.icon,this.press);
  final String description;
  final Widget icon;
  final void Function()? press;
  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          iconSize: 100,
          tooltip: description,
          icon: icon,
          onPressed: press, 
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10
          ),
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}