// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/others.dart';

Text whiteBoldText({ required String text }) => Text(text,style: whiteBoldStyle(),);

Text boldText({ required String text }) => Text(text,style: boldStyle(),);

Text boldHeaderText({ required BuildContext context,required String text }) => Text(text,style: boldHeaderStyle(context: context),);
Text whiteBoldHeaderText({ required BuildContext context, required String text }) => Text(text,style: whiteBoldHeaderStyle(context: context),);

Text focusHeaderText({ required BuildContext context, required String text }) => Text(text,style: focusHeaderStyle(context: context),);