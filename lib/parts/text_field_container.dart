import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color fieldColor;
  TextFieldContainer(this.child,this.fieldColor);

  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      width: size.width * 0.8 ,
      decoration: BoxDecoration(
        // color: fieldColor.withOpacity(0.7),
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.5)
        ),
        boxShadow: [
          BoxShadow(
            color: fieldColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10)
          )
        ],
        borderRadius: BorderRadius.circular(30)
      ),
      child: child,
    );
  }
}