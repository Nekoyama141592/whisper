import 'package:flutter/material.dart';

import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/bookmarks/components/bookmarks_card.dart';

import 'package:whisper/components/bookmarks/bookmarks_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    Key? key,
    required BookMarksModel bookmarksProvider,
    required this.currentUserDoc,
    required this.preservatedPostIds,
    required this.likedPostIds,
  }) : _bookmarksProvider = bookmarksProvider, super(key: key);

  final BookMarksModel _bookmarksProvider;
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
      
      SafeArea(
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
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BookMarks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                  ]
                ),
              ),
              SizedBox(height:5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)
                    )
                  ),
                  child: BookmarkCard(
                    _bookmarksProvider,
                    preservatedPostIds,
                    likedPostIds
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}