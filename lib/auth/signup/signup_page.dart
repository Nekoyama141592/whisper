import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          appBar: AppBar(
            title: Text('新規登録'),
          ),
          body: Column(
            children: [
              InkWell(
                child: Container(
                  width: 100,
                  height: 160,
                  child: _signupProvider.xfile != null ?
                  Image.file(_signupProvider.imageFile)
                  : Icon(Icons.image, size: 100,),
                ),
                onTap: () async {
                  await _signupProvider.showImagePicker();
                },
              ),
              TextField(
                controller: emailInputController,
                onChanged: (text) {
                  _signupProvider.email = text;
                },
              ),
              TextField(
                controller: passwordInputController,
                onChanged: (text) {
                  _signupProvider.password = text;
                },
                obscureText: true,
              ),
              
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  child: Text('signup'),
                  onPressed: () async {
                    await _signupProvider.signup(context);
                  },
                ),
              ),
            ]
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
