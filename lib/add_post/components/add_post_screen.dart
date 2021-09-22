import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/constants/colors.dart';

class AddPostScreen extends StatelessWidget {

  AddPostScreen(this.currentUserDoc,this.content);
  final DocumentSnapshot currentUserDoc;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                kPrimaryColor.withOpacity(0.9),
                kPrimaryColor.withOpacity(0.8),
                kPrimaryColor.withOpacity(0.4),
              ]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  
                ),
                child: Column(
                  
                  children: [
                    Text(
                      'Add Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height:10),
                    Container(
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(35)
                        )
                      ),
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                          ),
                          child: content
                          
                        ),
                      )
                    )
                  ]
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}