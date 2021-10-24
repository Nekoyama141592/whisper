// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

class ImportantMattersPage extends StatelessWidget {

  const ImportantMattersPage({
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
            onTap: () { routes.toTosPage(context); },
          ),
          ListTile(
            title: Text('プライバシーポリシー'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () { routes.toPrivacyPage(context); },
          ),
          ListTile(
            title: Text('コンプライアンスポリシー'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () { routes.toCompliancePage(context); },
          ),
        ],
      )
    );
  }
}