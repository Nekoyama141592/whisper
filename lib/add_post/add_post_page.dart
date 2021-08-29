import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_post_model.dart';

class AddPostPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _addPostProvider = watch(addPostProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('add'),
      ),
    );
  }
}