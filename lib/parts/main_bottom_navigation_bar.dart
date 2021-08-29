import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/main_model.dart';

import 'package:whisper/constants/routes.dart' as routes;
class MainBottomNavigationbar extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _mainProvider = watch(mainProvider);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: InkWell(
            child: Icon(Icons.home),
            onTap: () {routes.toMyApp(context);},
          )
        ),
        BottomNavigationBarItem(
          label: 'Logout',
          icon: InkWell(
            child: Icon(Icons.logout),
            onTap: () async {
              await showDialog(
                context: context,
                barrierDismissible: false, 
                builder: (context) {
                  return AlertDialog(
                    title: Text('確認'),
                    content: Text('ログアウトしますか？'),
                    actions: [
                      ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: (){
                          _mainProvider.logout(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ログアウトしました')));
                        },
                      )
                    ],
                  );
                }
              );
            },
          )
        ),
      ],
    );
  }
}