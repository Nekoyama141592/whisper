import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final roundedPasswordFieldProvider = ChangeNotifierProvider(
  (ref) => RoundedPasswordFieldModel()
);
class RoundedPasswordFieldModel extends ChangeNotifier{
  bool isObscure = true;

  void toggleIsObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}