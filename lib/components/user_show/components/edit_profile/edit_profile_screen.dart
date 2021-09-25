import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class EditProfileScreen extends ConsumerWidget {
  
  const EditProfileScreen({
    Key? key,
    required this.userShowProvider,
    required this.currentUserDoc
  }) : super(key: key);

  final UserShowModel userShowProvider;
  final DocumentSnapshot currentUserDoc;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final userNameController = TextEditingController(
      text: !userShowProvider.isEdited ? currentUserDoc['userName'] : userShowProvider.userName
    );
    final descriptionController = TextEditingController(
      text: !userShowProvider.isEdited ? currentUserDoc['description'] : userShowProvider.description
    );
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  userShowProvider.isEditing = false;
                  userShowProvider.reload();
                }, 
                child: Text('Cancel')
              ),
              SizedBox(width: size.width * 0.5,),
              RoundedButton(
                '保存', 
                0.25, 
                10, 
                5, 
                () async  {
                  await userShowProvider.onSaveButtonPressed(context,currentUserDoc);
                },
                Colors.white, 
                kPrimaryColor
              )
            ],
          ),
          CircleAvatar(
            backgroundColor: kTertiaryColor,
            radius: 24,
          ),
          Text('名前'),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: userNameController,
            onChanged: (text){
              userShowProvider.userName = text;
            },
          ),
          Text('自己紹介'),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            controller: descriptionController,
            onChanged: (text){
              userShowProvider.description = text;
            },
          ),
        ],
      ),
    );
  }
}