// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/auth/components/already_have_an_account.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
// model
import 'signup_model.dart';

class SignupPage extends ConsumerWidget {
  
  const SignupPage({
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signupModel = watch(signupProvider);
    final emailInputController = TextEditingController(text: signupModel.email);
    final passwordInputController = TextEditingController(text: signupModel.password);

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: false,
          body: SafeArea(
            child: signupModel.isLoading ?
            Loading()
            : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    kPrimaryColor.withOpacity(0.9),
                    kPrimaryColor.withOpacity(0.8),
                    kPrimaryColor.withOpacity(0.4),
                  ],
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // back arrow
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("新規登録", style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold)),
                        SizedBox(height: 10,),
                        Text("ようこそWhisperへ！", style: TextStyle(color: Colors.white, fontSize: 18),)
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)
                        )
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: signupModel.isCropped ?
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 25
                                    ),
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kTertiaryColor
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(signupModel.croppedFile!),
                                      )
                                    ),
                                  )
                                  : Column(
                                    children: [
                                      InkWell(
                                        child: Icon(Icons.image,size: 160.0),
                                        onTap: () async {
                                          await signupModel.showImagePicker();
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5
                                        ),
                                        child: Text('上のアイコンをタップして写真を選択',style: TextStyle(fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            RoundedInputField(
                              hintText: "Email",
                              icon: Icons.person,
                              controller: emailInputController,
                              onChanged:  (text) {
                                signupModel.email = text;
                              },
                              paste: (value) {
                                signupModel.email = value;
                              },
                            ),
                            RoundedPasswordField(
                              hintText: "password",
                              controller: passwordInputController,
                              onChanged:  (text) {
                                signupModel.password = text;
                              },
                              paste: (value) {
                                signupModel.password = value;
                              },
                            ),
                            
                            SizedBox(height: 24),
                            Center(
                              child: RoundedButton(
                                text: '次へ',
                                widthRate: 0.8,
                                verticalPadding: 20.0,
                                horizontalPadding: 10.0,
                                press: () {
                                  if (signupModel.croppedFile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('写真を選択してください')));
                                  } else {
                                    routes.toAddUserInfoPage(context, signupModel);
                                  }
                                },
                                textColor: Colors.white,
                                buttonColor: kSecondaryColor,
                              ),
                            ),
                            AlreadyHaveAnAccount()
                          ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
