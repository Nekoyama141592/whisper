
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/parts/loading.dart';
import 'package:whisper/parts/nothing.dart';

import 'user_show_model.dart';
import 'package:whisper/users/user_show/audio_controll/audio_window.dart';

class UserShowPage extends ConsumerWidget {
  final DocumentSnapshot doc;
  final List preservatedPostIds;
  final List likedPostIds;
  UserShowPage(this.doc,this.preservatedPostIds,this.likedPostIds);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _userShowProvider = watch(userShowProvider);
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: 
      SafeArea(
        child: Column(
          
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 25,
              ),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(doc['imageURL'])
                ),
              ),
            ),
            _userShowProvider.isLoading ?
            Loading()
            : _userShowProvider.postDocs.isEmpty ?
            Nothing()
            : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _userShowProvider.postDocs.length,
                    itemBuilder: (BuildContext context, int i) =>
                    ListTile(
                      title: Text(_userShowProvider.postDocs[i]['title']),
                    )
                  )
                ),
                AudioWindow(_userShowProvider,preservatedPostIds,likedPostIds)
              ],
            ),
          ],
        ),
      ),
    );
  }
}