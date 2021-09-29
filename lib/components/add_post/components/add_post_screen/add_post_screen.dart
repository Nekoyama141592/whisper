import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/constants/colors.dart';
import 'package:whisper/details/rounded_button.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/components/add_post/add_post_model.dart';
class AddPostScreen extends StatelessWidget {

  AddPostScreen({
    Key? key,
    required this.content,
    required this.addPostModel,
    required this.currentUserDoc
  }) : super(key: key);

  final Widget content;
  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
              Row(
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5
                ),
                child: Text(
                  'Add Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height:25),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(35)
                    )
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 20,
                            ),
                            child: content
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}