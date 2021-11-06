// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/posts/components/replys/components/reply_card/reply_card.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyCards extends StatelessWidget {

  const ReplyCards({
    Key? key,
    required this.thisComment,
    required this.mainModel,
    required this.replysModel
  }) : super(key: key);

  final Map<String,dynamic> thisComment;
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
        return !snapshot.hasData || snapshot.data == null  ?
        SizedBox.shrink()
        : 
        SmartRefresher(
          enablePullUp: true,
          enablePullDown: false,
          header: WaterDropHeader(),
          controller: replysModel.refreshController,
          onLoading: () {
            replysModel.onLoading(thisComment);
          },
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