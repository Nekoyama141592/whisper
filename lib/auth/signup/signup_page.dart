import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/auth/components/rounded_input_field.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
import 'package:whisper/auth/components/rounded_button.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/auth/components/already_have_an_account.dart';

import 'signup_model.dart';

class SignupPage extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _signupProvider = watch(signupProvider);
    final emailInputController = TextEditingController();
    final passwordInputController = TextEditingController();
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: false,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
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
                        color: Colors.white,
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
                                InkWell(
                                  child: _signupProvider.xfile != null ?
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 25
                                    ),
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: FileImage(_signupProvider.imageFile),
                                      )
                                    ),
                                  )
                                  : Icon(
                                    Icons.image,
                                    size: 160,
                                  ),
                                  onTap: () async {
                                    await _signupProvider.showImagePicker();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('アイコンをタップしてプロフィール画像を設定'),
                                )
                              ],
                            ),
                            RoundedInputField(
                              "Your Email",
                              Icons.person,
                              emailInputController,
                              (text) {
                                _signupProvider.email = text;
                              },
                              kPrimaryColor
                            ),
                            RoundedPasswordField(
                              "Your password",
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
                                () async {
                                  await _signupProvider.signup(context);
                                },
                                Colors.white,
                                kSecondaryColor
                              ),
                            ),
                            AlreadyHaveAnAccount(kTertiaryColor)
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
        : SizedBox()
      ],
    );
  }
}
