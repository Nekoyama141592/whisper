// material
import 'package:flutter/material.dart';

class PrivacyAndTos extends StatelessWidget {

  const PrivacyAndTos({
    Key? key
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('必要事項'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('利用規約'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: Text('プライバシーポリシー'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      )
    );
  }
}