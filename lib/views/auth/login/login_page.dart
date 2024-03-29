// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/details/loading.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/views/auth/login/components/forget_password_text.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_password_field.dart';
// models
import 'package:whisper/models/auth/login_model.dart';
import 'package:whisper/l10n/l10n.dart';

class LoginPage extends ConsumerWidget {

  const LoginPage({
    Key? key
  }) : super(key: key);

  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    final loginModel = ref.watch(loginProvider);
    final emailInputController = TextEditingController(text: loginModel.email);
    final passwordInputController = TextEditingController(text: loginModel.password,);
    final size = MediaQuery.of(context).size;
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: loginModel.isLoading ?
      Loading() :
      SafeArea(
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
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    routes.toSignupPage(context);
                  }, 
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding(context: context),
                  vertical: defaultPadding(context: context)/2.0,
                ),
                child: whiteBoldEllipsisHeaderText(context: context, text: l10n.signIn)
              ),
              SizedBox(height: defaultPadding(context: context) ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultPadding(context: context) * 2.0),
                      topRight: Radius.circular(defaultPadding(context: context) * 2.0),
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
                          hintText: l10n.email,
                          icon: Icons.person,
                          controller: emailInputController,
                          onChanged:  (text) => loginModel.email = text,
                          onCloseButtonPressed: () {
                            emailInputController.text = '';
                            loginModel.email = '';
                          },
                          paste: (value) => loginModel.email = value,
                        ),
                        RoundedPasswordField(
                          hintText: l10n.password, 
                          controller: passwordInputController, 
                          onChanged: (text) => loginModel.password = text,
                          paste: (value) => loginModel.password = value,
                        ),
                        SizedBox(height: defaultPadding(context: context) ),
                        Center(
                          child: RoundedButton(
                            text: l10n.signIn,
                            widthRate: 0.8,
                            fontSize: defaultHeaderTextSize(context: context),
                            press: () async => await loginModel.login(context: context ),
                            textColor: Colors.white,
                            buttonColor: kQuaternaryColor
                          ),
                        ),
                        ForgetPasswordText()
                      ]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}