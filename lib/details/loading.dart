// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';

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
              padding: EdgeInsets.all(20),
              child: Text('Loading'),
            ),
          ),
          Center(child: CircularProgressIndicator())
        ]
      ),
    );
  }
}