import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'signup_model.dart';

class SignupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _signupProvider = watch(signupProvider);
    final emailInputController = TextEditingController();
    final passwordInputController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Column(
        children: [
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
    );
  }
}
