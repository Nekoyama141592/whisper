import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/parts/posts/posts_model.dart';
import 'audio_controll/audio_state_design.dart';

class PostCard extends StatelessWidget{
  PostCard(this.documents,this.postsProvider);
  final List<DocumentSnapshot> documents;
  final PostsModel postsProvider;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int i) =>
              ListTile(
                title: Text(documents[i]['title']),
                trailing: IconButton(
                  icon: Icon(Icons.recommend),
                  onPressed: (){},
                ),
              )
          ),
        ),
        AudioStateDesign(postsProvider: postsProvider)
      ]
    );
  }
}