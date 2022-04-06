import 'package:flutter/material.dart';

double fullHeight({ required BuildContext context }) => MediaQuery.of(context).size.height;
double addPostIconSize({ required  BuildContext context }) => fullHeight(context: context)/12.5;
double defaultPadding({ required BuildContext context  }) => fullHeight(context: context)/50.0;
double defaultHeaderTextSize({ required BuildContext context  }) => fullHeight(context: context)/32.0;
double flashDialogueHeight({ required BuildContext context }) => fullHeight(context: context) * 0.70;

const double cardOpacity = 0.5;
const double notificationCardOpacity = 0.85;
const double cardTextDiv = 1.1;
const double cardTextDiv2 = 1.30;
const double notificationDiv = 1.30;
// score
const double defaultScore = 10000.0;
const double likeScore = 100.0;
const double bookmarkScore = 150.0;
