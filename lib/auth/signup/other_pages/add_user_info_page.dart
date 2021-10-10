// material
import 'package:flutter/material.dart';
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
            RoundedInputField(
              hintText: 'ニックネーム', 
              icon: Icons.person, 
              controller: userNameController, 
              onChanged: (text) {
                signupModel.userName = text;
              }
            ),
            RoundedButton(
              text: '新規登録',
               widthRate: 0.95, 
               verticalPadding: 20.0, 
               horizontalPadding: 10.0, 
               press: () async {
                 if (signupModel.userName.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ニックネームを入力してください')));
                 } else {
                   await signupModel.signup(context);
                 }
               }, 
               textColor: Colors.white, 
               buttonColor: Theme.of(context).colorScheme.secondary
              )
          ],
        )
      ),
    );
  }
 }
