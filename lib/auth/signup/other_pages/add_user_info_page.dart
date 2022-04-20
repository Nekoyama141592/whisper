// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/voids.dart' as voids;
// model
import 'package:whisper/auth/signup/signup_model.dart';
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_input_field.dart';
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
    final buttonWidthRate = 0.30;
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
            Padding(
              padding: EdgeInsets.all(defaultPadding(context: context) ),
              child: Center(
                child: ValueListenableBuilder<String>(
                  valueListenable: signupModel.displayGenderNotifier,
                  builder: (_,gender,__) {
                    return Column(
                      children: [
                        RoundedButton(
                          text: l10n.gender, 
                          widthRate: buttonWidthRate, 
                          fontSize: defaultHeaderTextSize(context: context),
                          press: () => signupModel.showGenderCupertinoActionSheet(context: context),
                          textColor: Colors.white, 
                          buttonColor: Theme.of(context).primaryColor
                        ),
                        SizedBox(height: defaultPadding(context: context) ),
                        if(gender.isNotEmpty) Text(gender,style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    );
                  }
                ),
              ),
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
                TextButton(onPressed: () => voids.defaultLaungh(context: context, url: tosURL ), 
                child: PositiveText(text: l10n.tos) ),
                Text(l10n.and),
                TextButton(onPressed: () => voids.defaultLaungh(context: context, url: privacyURL ), 
                child: PositiveText(text: l10n.privacyPolicy),),
                Text(l10n.agree)
              ],
            ),
            RoundedButton(
              text: l10n.signUp,
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => signupModel.userName.isEmpty || signupModel.gender.isEmpty || !signupModel.isCheckedNotifier.value ?
                voids.showBasicFlutterToast(context: context, msg: l10n.inputNotCompleted ) : await signupModel.signup(context: context),
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary
            ),
          ],
        )
      ),
    );
  }
 }
