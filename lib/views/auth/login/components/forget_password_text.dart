// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/l10n/l10n.dart';

class ForgetPasswordText extends StatelessWidget {
  
  const ForgetPasswordText({
    Key? key,
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: defaultPadding(context: context)
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
                text: l10n.forgetPassword,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: defaultHeaderTextSize(context: context)
                ),
                recognizer: TapGestureRecognizer()..onTap = () => routes.toVerifyPasswordResetPage(context),
              )
            ]
          )
        )
      ),
    );
  }
}