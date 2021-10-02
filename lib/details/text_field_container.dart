// material
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        width: size.width * 0.9 ,
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          border: Border.all(
            color: Colors.black.withOpacity(0.5)
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).highlightColor.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(0, 10)
            )
          ],
          borderRadius: BorderRadius.circular(30)
        ),
        child: child,
      ),
    );
  }
}