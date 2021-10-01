// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/user_image.dart';
// model
import 'package:whisper/components/user_show/user_show_model.dart';

class EditProfileScreen extends ConsumerWidget {
  
  const EditProfileScreen({
    Key? key,
    required this.userShowModel,
    required this.currentUserDoc
  }) : super(key: key);

  final UserShowModel userShowModel;
  final DocumentSnapshot currentUserDoc;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final userNameController = TextEditingController(
      text: !userShowModel.isEdited ? currentUserDoc['userName'] : userShowModel.userName
    );
    final descriptionController = TextEditingController(
      text: !userShowModel.isEdited ? currentUserDoc['description'] : userShowModel.description
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
                    userShowModel.isEditing = false;
                    userShowModel.reload();
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
                    await userShowModel.onSaveButtonPressed(context,currentUserDoc);
                  },
                  Colors.white, 
                  Theme.of(context).highlightColor
                )
              ],
            ),
            UserImage(userImageURL: currentUserDoc['imageURL'], length: 80.0, padding: 10.0),
            Text('名前'),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: userNameController,
              onChanged: (text){
                userShowModel.userName = text;
              },
            ),
            Text('自己紹介'),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              controller: descriptionController,
              onChanged: (text){
                userShowModel.description = text;
              },
            ),
          ],
        ),
      ),
    );
  }
}