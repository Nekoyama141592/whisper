import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_post_model.dart';
import 'package:whisper/add_post/components/add_post_screen/add_post_screen.dart';
import 'package:whisper/add_post/components/add_post_screen/components/add_post_content.dart';

class AddPostPage extends ConsumerWidget {

  AddPostPage(this.currentUserDoc);
  final DocumentSnapshot currentUserDoc;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _addPostProvider = watch(addPostProvider);
    return AddPostScreen(
      AddPostContent(
        _addPostProvider,
        currentUserDoc
      )
    );
  }
}

