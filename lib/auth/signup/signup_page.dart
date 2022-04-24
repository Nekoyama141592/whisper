// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/circle_image.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/auth/components/already_have_an_account.dart';
import 'package:whisper/details/rounded_password_field.dart';
// model
import 'signup_model.dart';

class SignupPage extends ConsumerWidget {
  
  const SignupPage({
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupModel = ref.watch(signupProvider);
    final emailInputController = TextEditingController(text: signupModel.email);
    final passwordInputController = TextEditingController(text: signupModel.password);
    final l10n = returnL10n(context: context);
    return Scaffold(
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
                  horizontal: defaultPadding(context: context),
                  vertical: defaultPadding(context: context)
                ),
                child: Text(l10n!.signUp, style: TextStyle(color: Colors.white, fontSize: defaultHeaderTextSize(context: context),fontWeight: FontWeight.bold)),
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
                        Column(
                          children: [
                            Container(
                              child: signupModel.isCropped ?
                              Padding(
                                padding: EdgeInsets.all(defaultPadding(context: context)),
                                child: CircleImage(length: defaultHeaderTextSize(context: context) * 5, image: FileImage(signupModel.croppedFile!)),
                              )
                              : Column(
                                children: [
                                  InkWell(
                                    child: Icon(Icons.image,size: defaultHeaderTextSize(context: context) * 5),
                                    onTap: () async => await signupModel.showImagePicker()
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: defaultPadding(context: context)
                                    ),
                                    child: boldText(text: l10n.selectImage)
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        RoundedInputField(
                          hintText: l10n.email,
                          icon: Icons.person,
                          controller: emailInputController,
                          onChanged:  (text) => signupModel.email = text,
                          onCloseButtonPressed: () {
                            emailInputController.text = '';
                            signupModel.email = '';
                          },
                          paste: (value) => signupModel.email = value,
                        ),
                        RoundedPasswordField(
                          hintText: l10n.password,
                          controller: passwordInputController,
                          onChanged:  (text) => signupModel.password = text,
                          paste: (value) => signupModel.password = value,
                        ),
                        
                        SizedBox(height: defaultPadding(context: context) ),
                        Center(
                          child: RoundedButton(
                            text: l10n.next,
                            widthRate: 0.8,
                            fontSize: defaultHeaderTextSize(context: context),
                            // press: () {
                            //   if (signupModel.croppedFile == null) {
                            //     showBasicFlutterToast(context: context, msg: l10n.pleaseChooseImage);
                            //   } else {
                            //     routes.toAddUserInfoPage(context, signupModel);
                            //   }
                            // },
                            press: () => signupModel.croppedFile == null ? 
                              showBasicFlutterToast(context: context, msg: l10n.pleaseSelectImage) : routes.toAddUserInfoPage(context, signupModel),
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
    );
  }
}
