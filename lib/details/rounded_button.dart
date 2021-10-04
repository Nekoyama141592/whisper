// material
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  
  const RoundedButton({
    Key? key,
    required this.text,
    required this.widthRate,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.press,
    required this.textColor,
    required this.buttonColor,
  }) : super(key:key);

  final String text;
  final double widthRate,verticalPadding,horizontalPadding;
  final Function()? press;
  final Color textColor, buttonColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * widthRate,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ElevatedButton(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
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