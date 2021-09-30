// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_svg/svg.dart';

class Nothing extends StatelessWidget {
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
              'assets/svgs/Search-rafiki.svg',
              height: size.height * 0.30,
            ),
          ),
          Center(
            child: Text(
              'Nothing',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),
            ),
          )
        ],
      ),
    );
  }
}