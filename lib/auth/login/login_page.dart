import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/constants/routes.dart' as routes;

class LoginPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(

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