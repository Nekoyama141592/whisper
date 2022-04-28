// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/widgets.dart';

class Loading extends StatelessWidget {

  const Loading({
    Key? key
  }) : super(key: key);
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/svgs/Processing-bro.svg",
              height: size.height * 0.30,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(defaultPadding(context: context)),
              child: boldEllipsisHeaderText(context: context,text: loadingText)
            ),
          ),
          Center(child: CircularProgressIndicator())
        ]
      ),
    );
  }
}