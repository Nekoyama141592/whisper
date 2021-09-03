import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/constants/routes.dart' as routes;
class WhisperButtomNavigationbar extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
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
          label: 'Add',
          icon: InkWell(
            child: Icon(Icons.new_label),
            onTap: () {routes.toAddPostsPage(context);},
          )
        ),
        
        BottomNavigationBarItem(
          label: 'sample',
          icon: Icon(Icons.add)
        ),
      ],
    );
  }
}