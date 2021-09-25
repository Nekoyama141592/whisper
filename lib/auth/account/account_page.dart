import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account_model.dart';

class AccountPage extends ConsumerWidget {

  AccountPage(this.currentUserDoc);
  final DocumentSnapshot currentUserDoc;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final _accountModel = watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
    );
  }
}