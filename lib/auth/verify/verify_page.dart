import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/auth/verify/verify_model.dart';

class VerifyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _verifyProider = watch(verifyProvider);
    String userEmail = _verifyProider.currentUser!.email.toString();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
                'An email has been sent to $userEmail please verify'),
          ),
          ElevatedButton(
            child: Text('始める'),
            onPressed: () {
              _verifyProider.checkEmailVerified(context);
            }, 
          )
        ],
      ),
    );
  }
}