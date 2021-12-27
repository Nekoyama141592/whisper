// material
import 'package:flutter/material.dart';

class ShowDescriptionPage extends StatelessWidget {

  const ShowDescriptionPage({
    Key? key,
    required this.description
  }) : super(key: key);
  
  final String description;

  @override 
  Widget build(BuildContext context) {
    
    final textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('自己紹介'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(description,style: textStyle)
            ],
          ),
        ),
      ),
    );
  }
}