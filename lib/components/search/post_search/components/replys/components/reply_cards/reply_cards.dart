// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/search/post_search/components/replys/components/reply_card/reply_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class ReplyCards extends StatelessWidget {

  const ReplyCards({
    Key? key,
    required this.mainModel,
    required this.searchReplysModel
  }) : super(key: key);

  final MainModel mainModel;
  final SearchReplysModel searchReplysModel;

  @override 
  
  Widget build(BuildContext context) {

    return searchReplysModel.isLoading ?
    Loading()
    : StreamBuilder(
      stream: searchReplysModel.replysStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) Text('something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting) Loading();
        return !snapshot.hasData || snapshot.data == null ?
        SizedBox.shrink()
        : Center(
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> reply = doc.data()! as Map<String, dynamic>;
              return ReplyCard(reply: reply, searchReplysModel: searchReplysModel, mainModel: mainModel);
            }).toList(),
          ),
        );
      }
    );
  }

}