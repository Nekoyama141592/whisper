import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

class RoundedButton extends StatelessWidget {
  
  final String text;
  Function()? press;
  final Color textColor, buttonColor;
  RoundedButton(
    this.text,
    this.press,
    this.textColor,
    this.buttonColor
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: buttonColor.withOpacity(0.9)
          ),
          onPressed: press, 
        ),
      ),
    );
  }
}