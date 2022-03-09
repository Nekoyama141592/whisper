// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/auth/signup/signup_model.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_input_field.dart';

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
                onPressed: () {
                  Navigator.pop(context);
                }, 
              ),
            ),
            RoundedInputField(
              hintText: 'ニックネーム', 
              icon: Icons.person, 
              controller: userNameController, 
              onChanged: (text) {
                signupModel.userName = text;
              },
              onCloseButtonPressed: () {
                userNameController.text = '';
                signupModel.userName = '';
              },
              paste: (value) {
                signupModel.userName = value;
              },
            ),
            Padding(
              padding: EdgeInsets.all(defaultPadding(context: context) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<DateTime>(
                    valueListenable: signupModel.displayBirthDayNotifier,
                    builder: (_,birthDay,__) {
                      return Column(
                        children: [
                          RoundedButton(
                            text: '生年月日', 
                            widthRate: buttonWidthRate, 
                            fontSize: defaultHeaderTextSize(context: context),
                            press: () {
                             signupModel.showCupertinoDatePicker(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: defaultPadding(context: context) ),
                          if (birthDay != DateTime(1900,10,10)) Text(
                            birthDay.year.toString() + '年' + birthDay.month.toString() + '月' + birthDay.day.toString() + '日'
                          )
                        ],
                      );
                    }
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: signupModel.displayLanguageNotifier,
                    builder: (_,language,__) {
                      return Column(
                        children: [
                          RoundedButton(
                            text: '言語', 
                            widthRate: buttonWidthRate, 
                            fontSize: defaultHeaderTextSize(context: context),
                            press: () {
                              signupModel.showLanguageCupertinoActionSheet(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: defaultPadding(context: context) ),
                          if(language.isNotEmpty) Text(language,style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      );
                    }
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: signupModel.displayGenderNotifier,
                    builder: (_,gender,__) {
                      return Column(
                        children: [
                          RoundedButton(
                            text: '性別', 
                            widthRate: buttonWidthRate, 
                            fontSize: defaultHeaderTextSize(context: context),
                            press: () {
                              signupModel.showGenderCupertinoActionSheet(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: defaultPadding(context: context) ),
                          if(gender.isNotEmpty) Text(gender,style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: signupModel.isCheckedNotifier,
                  builder: (_,isChecked,__) {
                    return InkWell(
                      child: isChecked ?
                      Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
                      onTap: () {
                        signupModel.toggleIsChecked();
                      },
                    );
                  }
                ),
                TextButton(onPressed: () {
                  voids.defaultLaungh(context: context, url: tosURL );
                }, child: Text(
                  '利用規約',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold
                  ),
                )),
                Text('と'),
                TextButton(onPressed: () {
                  voids.defaultLaungh(context: context, url: privacyURL );
                }, child: Text(
                  'プライバシーポリシー',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold
                  ),
                )),
                Text('に同意する')
              ],
            ),
            RoundedButton(
              text: '新規登録',
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async {
                if (signupModel.userName.isEmpty || signupModel.gender.isEmpty || signupModel.birthDay == DateTime(1900,10,10) || !signupModel.isCheckedNotifier.value || signupModel.language.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('入力が完了していません。ご確認ください。')));
                } else {
                  await signupModel.signup(context);
                }
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary
            ),
          ],
        )
      ),
    );
  }
 }
