// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/replys/components/reply_card/reply_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyCards extends StatelessWidget {

  const ReplyCards({
    Key? key,
    required this.mainModel,
    required this.replysModel
  }) : super(key: key);

  final MainModel mainModel;
  final ReplysModel replysModel;

  @override 
  
  Widget build(BuildContext context) {

    return replysModel.isLoading ?
    Loading()
    : StreamBuilder(
      stream: replysModel.replysStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) Text('something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting) Loading();
        return !snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty ?
        SizedBox.shrink()
        : Center(
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              Map<String, dynamic> reply = doc.data()! as Map<String, dynamic>;
              return ReplyCard(reply: reply, replysModel: replysModel, mainModel: mainModel);
            }).toList(),
          ),
        );
      }
    );
  }

}