import 'package:flutter/material.dart';

double addPostIconSize({ required  BuildContext context }) {
  return MediaQuery.of(context).size.height/10.0;
}

double defaultPadding({ required BuildContext context  }) {
  return MediaQuery.of(context).size.height/50.0;
}

double defaultHeaderTextSize({ required BuildContext context  }) {
  return MediaQuery.of(context).size.height/32.0;
}

const double cardOpacity = 0.5;
const double cardTextDiv = 1.1;
const double cardTextDiv2 = 1.25;