import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'edit_profile_model.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({
    Key? key,
    required this.currentUserDoc
  }) : super(key: key);
  final DocumentSnapshot currentUserDoc;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final _editProfileProvider = watch(editProfileProvider);
    final userNameController = TextEditingController(
      text: currentUserDoc['userName']
    );
    final descriptionController = TextEditingController(
      text: currentUserDoc['description']
    );
    
    return Visibility(
      visible: _editProfileProvider.isVisible,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity * 0.95,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: kTertiaryColor,
              radius: 24,
            ),
            Text('名前'),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: userNameController,
              onChanged: (text){
                _editProfileProvider.userName = text;
              },
            ),
            Text('自己紹介'),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              controller: descriptionController,
              onChanged: (text){
                _editProfileProvider.description = text;
              },
            ),
          ],
        ),
      ),
    );
  }
}