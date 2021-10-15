// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

class ForgetPasswordText extends StatelessWidget {
  
  const ForgetPasswordText({
    Key? key,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: 5
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
            children: [
              TextSpan(
                text: 'パスワードを忘れた場合',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  routes.toVerifyPasswordResetPage(context);
                }
              )
            ]
          )
        )
      ),
    );
  }
}