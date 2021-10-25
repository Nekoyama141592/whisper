// material
import 'package:flutter/material.dart';

class TosPage extends StatelessWidget {

  const TosPage({
    Key? key
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
          )
        ),
      ),
    );
  }
  
}