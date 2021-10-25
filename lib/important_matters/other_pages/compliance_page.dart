// material
import 'package:flutter/material.dart';

class CompliancePage extends StatelessWidget {

  const CompliancePage({
    Key? key
  }) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('コンプライアンスポリシー'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
          )
        ),
      ),
    );
  }
}