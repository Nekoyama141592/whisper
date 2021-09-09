import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class Nothing extends StatelessWidget {
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/Search-rafiki.svg',
            height: size.height * 0.30,
          ),
          Text('Nothing')
        ],
      ),
    );
  }
}