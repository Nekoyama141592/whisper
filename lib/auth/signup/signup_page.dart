// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
import 'package:whisper/auth/components/already_have_an_account.dart';
import 'package:whisper/auth/components/forget_password_text.dart';
// model
import 'signup_model.dart';

class SignupPage extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _signupProvider = watch(signupProvider);
    final emailInputController = TextEditingController(text: _signupProvider.email);
    final passwordInputController = TextEditingController(text: _signupProvider.password);
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: false,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
            backgroundColor: kPrimaryColor,
            onPressed: () async {
              await _signupProvider.showImagePicker();
            }
          ),
          body: SafeArea(
            child: Container(
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
                        Text("新規登録", style: TextStyle(color: Colors.white, fontSize: 30)),
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
                                  child: _signupProvider.isCropped ?
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
                                        image: FileImage(_signupProvider.croppedFile!),
                                      )
                                    ),
                                  )
                                  : Column(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 160,
                                      ),
                                      
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5
                                        ),
                                        child: Text('右下のボタンで写真を選択',style: TextStyle(fontWeight: FontWeight.bold),),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            RoundedInputField(
                              "Email",
                              Icons.person,
                              emailInputController,
                              (text) {
                                _signupProvider.email = text;
                              },
                            ),
                            RoundedPasswordField(
                              "password",
                              passwordInputController,
                              (text) {
                                _signupProvider.password = text;
                              },
                              kPrimaryColor,
                              
                            ),
                            
                            SizedBox(height: 24),
                            Center(
                              child: RoundedButton(
                                'signup',
                                0.8,
                                20,
                                10,
                                () async {
                                  await _signupProvider.signup(context);
                                },
                                Colors.white,
                                kSecondaryColor
                              ),
                            ),
                            AlreadyHaveAnAccount(textColor: kTertiaryColor),
                            ForgetPasswordText(textColor: kTertiaryColor,)
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
        _signupProvider.isLoading ?
        Container(
          color: Colors.grey.withOpacity(0.7),
          child: Center(child: CircularProgressIndicator(),),
        )
        : SizedBox.shrink()
      ],
    );
  }
}
