// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/details/user_image.dart';

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
      child: SingleChildScrollView(
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
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 25
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.4,),
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
            UserImage(userImageURL: currentUserDoc['imageURL'], length: 80.0, padding: 10.0),
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
      ),
    );
  }
}