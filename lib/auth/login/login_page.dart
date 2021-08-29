import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/auth/login/login_model.dart';

class LoginPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _loginProvider = watch(loginProvider);
    final emailInputController = TextEditingController();
    final passwordInputController = TextEditingController();
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          currentUser == null ?
          SizedBox()
          : Text(currentUser.uid),
          TextField(
            controller: emailInputController,
            onChanged: (text){
              _loginProvider.email = text;
            },
          ),
    
          TextField(
            controller: passwordInputController,
            onChanged: (text) {
              _loginProvider.password = text;
            },
            obscureText: true,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            child: Text('ログイン'),
            onPressed: () async {
              await _loginProvider.login(context);
            }, 
          ),
          RichText(
            text: TextSpan(
              style: Theme.of(context)
              .textTheme
              // .headline5!
              // .bodyText2!
              .headline6!
              .copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: 'アカウントをお持ちでないなら'),
                TextSpan(
                  text: '新規登録',
                  style: TextStyle(
                    color: Colors.purple
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    routes.toSignupPage(context);
                  }
                )
              ]
            )
          )
        ],
      ),
    );
  }
}