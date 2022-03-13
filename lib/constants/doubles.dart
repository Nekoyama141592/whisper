import 'package:flutter/material.dart';

double addPostIconSize({ required  BuildContext context }) {
  return MediaQuery.of(context).size.height/12.5;
}

double defaultPadding({ required BuildContext context  }) {
  return MediaQuery.of(context).size.height/50.0;
}

double defaultHeaderTextSize({ required BuildContext context  }) {
  return MediaQuery.of(context).size.height/32.0;
}

const double cardOpacity = 0.5;
const double notificationCardOpacity = 0.85;
const double cardTextDiv = 1.1;
const double cardTextDiv2 = 1.30;
const double notificationDiv = 1.30;
