// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/others.dart';

Text whiteBoldText({ required String text }) => Text(text,style: whiteBoldStyle(),);

Text boldEllipsisText({ required String text }) => Text(text,style: boldEllipsisStyle(),);

Text boldText({ required String text }) => Text(text,style: boldStyle(),);

Text boldEllipsisHeaderText({ required BuildContext context,required String text }) => Text(text,style: boldEllipsisHeaderStyle(context: context),);

Text whiteBoldEllipsisHeaderText({ required BuildContext context, required String text }) => Text(text,style: whiteBoldEllipsisHeaderStyle(context: context),);

Text focusHeaderText({ required BuildContext context, required String text }) => Text(text,style: focusHeaderStyle(context: context),);

Text likeText({required String text }) => Text(text,style: likeStyle(),); 