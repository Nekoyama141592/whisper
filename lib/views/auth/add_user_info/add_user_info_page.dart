// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_input_field.dart';
// models
import 'package:whisper/models/auth/signup_model.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';

class AddUserInfoPage extends StatelessWidget {

  const AddUserInfoPage({
    Key? key,
    required this.signupModel
  }) : super(key: key);
  
  final SignupModel signupModel;

  @override 
  Widget build(BuildContext context) {
    final userNameController = TextEditingController(text: signupModel.userName);
    
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: Theme.of(context).focusColor,
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            RoundedInputField(
              hintText: l10n.nickname, 
              icon: Icons.person, 
              controller: userNameController, 
              onChanged: (text) => signupModel.userName = text,
              onCloseButtonPressed: () {
                userNameController.text = '';
                signupModel.userName = '';
              },
              paste: (value) => signupModel.userName = value,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: signupModel.isCheckedNotifier,
                  builder: (_,isChecked,__) {
                    return InkWell(
                      child: isChecked ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                      onTap: () => signupModel.toggleIsChecked()
                    );
                  }
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: l10n.tos,
                        style: highlightDiv2Style(context: context),
                        recognizer: TapGestureRecognizer()..onTap = () async => await voids.defaultLaungh(context: context, url: tosURL)
                      ),
                      TextSpan(text: l10n.and,style: div2EllipsisStyle(context: context) ),
                      TextSpan(
                        text: l10n.privacyPolicy,
                        style: highlightDiv2Style(context: context),
                        recognizer: TapGestureRecognizer()..onTap = () async => await voids.defaultLaungh(context: context, url: privacyURL)
                      ),
                      TextSpan(text: l10n.accept,style: div2EllipsisStyle(context: context) ),
                    ]
                  ),
                )
              ],
            ),
            RoundedButton(
              text: l10n.signUp,
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await signupModel.signup(context: context),
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary
            ),
          ],
        )
      ),
    );
  }
 }
