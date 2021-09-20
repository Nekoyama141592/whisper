import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/colors.dart';

class Loading extends StatelessWidget {
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: kBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svgs/Processing-bro.svg",
              height: size.height * 0.30,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Loading'),
            ),
            CircularProgressIndicator()
          ]
        ),
      ),
    );
  }
}