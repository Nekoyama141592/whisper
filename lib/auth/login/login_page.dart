// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
import 'package:whisper/details/rounded_button.dart';
// models
import 'package:whisper/auth/login/login_model.dart';

class LoginPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _loginProvider = watch(loginProvider);
    final emailInputController = TextEditingController(text: _loginProvider.email);
    final passwordInputController = TextEditingController(text: _loginProvider.password,);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: false,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    kTertiaryColor.withOpacity(0.9),
                    kTertiaryColor.withOpacity(0.8),
                    kTertiaryColor.withOpacity(0.4)
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
                      onPressed: () {
                        routes.toSignupPage(context);
                      }, 
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ログイン", style: TextStyle(color: Colors.white, fontSize: 30)),
                        SizedBox(height: 10,),
                        Text("お帰りなさい", style: TextStyle(color: Colors.white, fontSize: 18),)
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
                            SvgPicture.asset(
                              'assets/svgs/login-bro.svg',
                              height: size.height * 0.30,
                            ),
                            RoundedInputField(
                              "Your Email",
                              Icons.person,
                              emailInputController,
                              (text) {
                                _loginProvider.email = text;
                              },
                            ),
                            RoundedPasswordField(
                              "Your password",
                              passwordInputController,
                              (text) {
                                _loginProvider.password = text;
                              },
                              kTertiaryColor,
                              
                            ),
                            
                            SizedBox(height: 24),
                            Center(
                              child: RoundedButton(
                                'login',
                                0.8,
                                20,
                                10,
                                () async {
                                  await _loginProvider.login(context);
                                },
                                Colors.white,
                                kQuaternaryColor
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
        _loginProvider.isLoading ?
        Container(
          color: Colors.grey.withOpacity(0.7),
          child: Center(child: CircularProgressIndicator(),),
        )
        : SizedBox()
      ],
    );
  }
}