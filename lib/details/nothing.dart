// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_button.dart';

class Nothing extends StatelessWidget {

  const Nothing({
    Key? key,
    required this.reload,
  }) : super(key: key);

  final void Function()? reload;
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/svgs/Search-rafiki.svg',
              height: size.height * 0.30,
            ),
          ),
          Center(
            child: Text(
              'Nothing',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: defaultHeaderTextSize(context: context)
              ),
            ),
          ),
          RoundedButton(text: '再読み込み', widthRate: 0.95, fontSize: defaultHeaderTextSize(context: context),press: reload, textColor: Theme.of(context).focusColor, buttonColor: Theme.of(context).highlightColor)
        ],
      ),
    );
  }
}