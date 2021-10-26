// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class EditProfileScreen extends ConsumerWidget {
  
  const EditProfileScreen({
    Key? key,
    required this.userShowModel,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);

  final UserShowModel userShowModel;
  final DocumentSnapshot currentUserDoc;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final userNameController = TextEditingController(
      text: currentUserDoc['userName'] 
    );
    final descriptionController = TextEditingController(
      text: currentUserDoc['description']
    );
    final linkController = TextEditingController(text: currentUserDoc['link']);

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
                  text: '保存', 
                  widthRate: 0.25, 
                  verticalPadding: 10.0, 
                  horizontalPadding: 5.0, 
                  press: () async  {
                    await userShowModel.onSaveButtonPressed(context,currentUserDoc);
                    await mainModel.regetCurrentUserDoc(currentUserDoc.id);
                  },
                  textColor: Colors.white, 
                  buttonColor: Theme.of(context).highlightColor
                )
              ],
            ),
            
            InkWell(child: UserImage(userImageURL: currentUserDoc['imageURL'], length: 80.0, padding: 10.0),onTap: () async { await userShowModel.showImagePicker(); },),
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
            Text('リンク'),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'https://'
              ),
              controller: linkController,
              onChanged: (text){
                userShowModel.link = text;
              },
            ),
          ],
        ),
      ),
    );
  }
}