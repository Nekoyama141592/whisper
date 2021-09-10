import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/rounded_button.dart';
import 'admin_model.dart';

class AdminPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _adminProvider = watch(adminProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              'add description to users', 
              (){
                _adminProvider.addDescriptionToUser();
              }, 
              Colors.white, 
              kSecondaryColor
            ),
          )
        ],
      ),
    );
  }
}