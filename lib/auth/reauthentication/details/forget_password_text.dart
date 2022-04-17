// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
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
        child: TextButton(
          onPressed: () async {
            final currentUser = FirebaseAuth.instance.currentUser;
            final String email = currentUser!.email!;
            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
            voids.showBasicFlutterToast(context: context, msg: email + 'にメールを送信しました');
          },
          child: Text(
            l10n.forgetPassword,
            style: TextStyle(
              color: Theme.of(context).highlightColor,
              fontWeight: FontWeight.bold,
              fontSize: defaultHeaderTextSize(context: context)
            ),
          )
        ),
      ),
    );
  }
}