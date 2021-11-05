import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {

  // AudioButton(this.description,this.icon,this.press);
  const AudioButton({
    Key? key,
    required this.description,
    required this.icon,
    required this.press
  }) : super(key: key);
  
  final String description;
  final Widget icon;
  final void Function()? press;
  
  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: icon,
          onTap: press,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5
          ),
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            ),
          ),
        )
      ],
    );
  }
}