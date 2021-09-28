import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:whisper/constants/routes.dart' as routes;

class AlreadyHaveAnAccount extends StatelessWidget{

  AlreadyHaveAnAccount({
    Key? key,
    required this.textColor
  }) : super(key: key);
  final Color textColor;

  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: 25
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'すでにアカウントをお持ちですか？'
              ),
              TextSpan(
                text: 'ログイン',
                style: TextStyle(
                  color: textColor,fontSize: 18
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  routes.toLoginpage(context);
                }
              )
            ]
          )
        )
      ),
    );
  }
}