import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/auth/components/rounded_input_field.dart';
import 'package:whisper/auth/components/rounded_password_field.dart';
import 'package:whisper/auth/components/rounded_button.dart';
import 'package:whisper/constants/colors.dart';

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
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                    ),
                  ),
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
                        Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)
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
                            InkWell(
                              child: _signupProvider.xfile != null ?
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 25
                                ),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: FileImage(_signupProvider.imageFile),
                                  )
                                ),
                              )
                              : Container(
                                width: 100,
                                height: 160,
                                child:  Icon(Icons.image)
                              ),
                              onTap: () async {
                                await _signupProvider.showImagePicker();
                              },
                            ),
                            RoundedInputField(
                              "Your Email",
                              Icons.person,
                              emailInputController,
                              (text) {
                                _signupProvider.email = text;
                              },
                            ),
                            RoundedPasswordField(
                              "Your password",
                              passwordInputController,
                              (text) {
                                _signupProvider.password = text;
                              }
                            ),
                            
                            SizedBox(height: 24),
                            Center(
                              child: RoundedButton(
                                'signup',
                                () async {
                                  await _signupProvider.signup(context);
                                },
                                Colors.white
                              ),
                            )
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
