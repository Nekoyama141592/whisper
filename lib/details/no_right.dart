// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/l10n/l10n.dart';

class NoRight extends StatelessWidget {

  const NoRight({
    Key? key
  }) : super(key: key);
  
  @override  
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return Column(
      children: [
        Center(
          child: boldEllipsisHeaderText(context: context, text: l10n.noRight),
        )
      ],
    );
  }
}