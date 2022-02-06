// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';

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
        margin: EdgeInsets.symmetric(vertical: defaultPadding(context: context)),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding(context: context)/2.0,
          vertical: defaultPadding(context: context)/2.0,
        ),
        width: size.width * 0.9 ,
        decoration: BoxDecoration(
          // color: Theme.of(context).focusColor,
          color: Colors.white,
          border: Border.all(
            color: Colors.black.withOpacity(0.5)
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.3),
              blurRadius: defaultPadding(context: context),
              offset: Offset(0, 0)
            )
          ],
          borderRadius: BorderRadius.circular(15)
        ),
        child: child,
      ),
    );
  }
}