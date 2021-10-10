// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/auth/verify/verify_model.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/details/rounded_button.dart';

class VerifyPage extends ConsumerWidget {

  const VerifyPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final verifyModel = watch(verifyProvider);
    String userEmail = verifyModel.currentUser!.email.toString();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            userEmail + 'にメールを送信しました。ご確認下さい。',
            style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),
          ),
          RoundedButton(
            text: '始める', 
            widthRate: 0.95, 
            verticalPadding: 20.0, 
            horizontalPadding: 10.0, 
            press: () async {
              await verifyModel.setTimer(context);
              await verifyModel.checkEmailVerified(context);
            }, 
            textColor: Colors.white,
            buttonColor: Theme.of(context).highlightColor,
          ),
          
        ],
      ),
    );
  }
}