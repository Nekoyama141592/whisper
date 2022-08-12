// material
import 'package:flutter/material.dart';

class GradientScreen extends StatelessWidget {

  const GradientScreen({
    Key? key,
    required this.top,
    required this.header,
    required this.child,
    required this.circular
  }) : super(key: key);
  
  final Widget top;
  final Widget header;
  final Widget child;
  final double circular;

  @override  
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.9),
              Theme.of(context).primaryColor.withOpacity(0.4),
              Theme.of(context).primaryColor.withOpacity(0.1),
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            top,
            header,
            SizedBox(height: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(circular),
                    topRight: Radius.circular(circular)
                  )
                ),
                child: child,
              )
            ) 
          ]
        ),
      )
    );
  }
}