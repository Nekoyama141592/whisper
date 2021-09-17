import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/preservations/preservations_model.dart';
import 'package:whisper/preservations/components/preservation_card.dart';

class PreservationsPage extends ConsumerWidget {
  PreservationsPage(this.currentUserDoc,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _preservationsProvider = watch(preservationsProvider);
    return Scaffold(
      body: PostScreen(
        preservationsProvider: _preservationsProvider,
        currentUserDoc: currentUserDoc, 
        preservatedPostIds: preservatedPostIds, 
        likedPostIds: likedPostIds
      )
    );
  }
}

class PostScreen extends StatelessWidget {
  const PostScreen({
    Key? key,
    required PreservationsModel preservationsProvider,
    required this.currentUserDoc,
    required this.preservatedPostIds,
    required this.likedPostIds,
  }) : _preservationsProvider = preservationsProvider, super(key: key);

  final PreservationsModel _preservationsProvider;
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
                  child: PreservationCard(
                    _preservationsProvider,
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