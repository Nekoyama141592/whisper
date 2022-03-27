// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// model
import 'package:whisper/auth/verify/verify_model.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/details/rounded_button.dart';
// main.dart
import 'package:whisper/main.dart';

class VerifyPage extends ConsumerWidget {

  const VerifyPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final verifyModel = ref.watch(verifyProvider);
    final textStyle = TextStyle(fontSize: defaultHeaderTextSize(context: context),fontWeight: FontWeight.bold);
    String userEmail = verifyModel.currentUser!.email.toString();
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: defaultPadding(context: context)),
                  child: SvgPicture.asset(
                    'assets/svgs/key-pana.svg',
                    height: size.height * 0.30,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  userEmail + 'にメールを送信しました。ご確認下さい。',
                  style: textStyle
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  '送信されたメールのリンクを押したら以下のボタンを押してください',
                  style: textStyle,
                ),
                SizedBox(height: size.height * 0.05),
                RoundedButton(
                  text: '始める', 
                  widthRate: 0.95, 
                  fontSize: defaultHeaderTextSize(context: context),
                  press: () async {
                    await verifyModel.setTimer(context);
                    await verifyModel.checkEmailVerified(context);
                  }, 
                  textColor: Colors.white,
                  buttonColor: Theme.of(context).highlightColor,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}