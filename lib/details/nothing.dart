// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';

class Nothing extends StatelessWidget {

  const Nothing({
    Key? key,
    required this.reload,
  }) : super(key: key);

  final void Function()? reload;
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final L10n l10n = returnL10n(context: context)!;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/svgs/Search-rafiki.svg',
              height: size.height * 0.30,
            ),
          ),
          Center(
            child: boldEllipsisHeaderText(context: context, text: nothingText),
          ),
          RoundedButton(text: l10n.reload, widthRate: 0.95, fontSize: defaultHeaderTextSize(context: context),press: reload, textColor: Colors.white, buttonColor: Theme.of(context).highlightColor)
        ],
      ),
    );
  }
}