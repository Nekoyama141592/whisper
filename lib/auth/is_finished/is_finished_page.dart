// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/gradient_screen.dart';

class IsFinishedPage extends StatelessWidget {

  const IsFinishedPage({
    Key? key,
    required this.title,
    required this.text
  }) : super(key: key);

  final String title;
  final String text;

  @override 
  
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GradientScreen(
        top: SizedBox.shrink(), 
        header: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: Text(
            title,
            style: TextStyle(
              fontSize: defaultHeaderTextSize(context: context),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        circular: defaultPadding(context: context),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: defaultPadding(context: context)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/coffee_break_pana .svg',
                  height: size.height * 0.3,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: defaultPadding(context: context)
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: defaultHeaderTextSize(context: context) * 1.25,
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