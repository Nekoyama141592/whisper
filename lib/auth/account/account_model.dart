import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountProvider = ChangeNotifierProvider(
  (ref) => AccountModel()
);

class AccountModel extends ChangeNotifier {

}