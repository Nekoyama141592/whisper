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
    return Scaffold(
      appBar: AppBar(title: Text('description')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(description)
            ],
          ),
        ),
      ),
    );
  }
}