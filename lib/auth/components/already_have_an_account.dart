// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

class AlreadyHaveAnAccount extends StatelessWidget{

  const AlreadyHaveAnAccount({
    Key? key,
  }) : super(key: key);

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
                text: 'すでにアカウントをお持ちですか？',
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                )
              ),
              TextSpan(
                text: 'ログイン',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
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