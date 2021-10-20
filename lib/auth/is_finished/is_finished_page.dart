// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_svg/svg.dart';
// components
import 'package:whisper/details/gradient_screen.dart';

class IsFinishedPage extends StatelessWidget {

  const IsFinishedPage({
    Key? key,
    required this.text
  }) : super(key: key);

  final String text;

  @override 
  
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GradientScreen(
        top: SizedBox.shrink(), 
        header: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        circular: 30.0,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/coffee_break_pana .svg',
                  height: size.height * 0.3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20
                  ),
                  child: Text(
                    'お疲れ様でした',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ), 
      ),
    );
  }

}