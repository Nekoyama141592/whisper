// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// constants
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              }
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                            widthRate: 0.45, 
                            verticalPadding: 20, 
                            horizontalPadding: 10, 
                            press: () {
                             signupModel.showCupertinoDatePicker(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: 8.0),
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
                            widthRate: 0.45, 
                            verticalPadding: 20, 
                            horizontalPadding: 10, 
                            press: () {
                              signupModel.showLanguageCupertinoActionSheet(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: 8.0),
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
                            widthRate: 0.45, 
                            verticalPadding: 20, 
                            horizontalPadding: 10, 
                            press: () {
                              signupModel.showGenderCupertinoActionSheet(context);
                            }, 
                            textColor: Colors.white, 
                            buttonColor: Theme.of(context).primaryColor
                          ),
                          SizedBox(height: 8.0),
                          if(gender.isNotEmpty) Text(gender,style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
            RoundedButton(
              text: '新規登録',
              widthRate: 0.95, 
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
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
            SizedBox(height: 16.0),
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
                  routes.toTosPage(context);
                }, child: Text(
                  '利用規約',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold
                  ),
                )),
                Text('と'),
                TextButton(onPressed: () {
                  routes.toPrivacyPage(context);
                }, child: Text(
                  'プライバシーポリシー',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold
                  ),
                )),
                Text('に同意する')
              ],
            )
          ],
        )
      ),
    );
  }
 }
