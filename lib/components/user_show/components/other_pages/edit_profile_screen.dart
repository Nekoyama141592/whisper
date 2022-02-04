// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/circle_image.dart';
import 'package:whisper/details/rounded_button.dart';
// model
import 'package:whisper/main_model.dart';

class EditProfileScreen extends StatelessWidget {
  
  const EditProfileScreen({
    Key? key,
    required this.onCancelButtonPressed,
    required this.onSaveButtonPressed,
    required this.showImagePicker,
    required this.onUserNameChanged,
    required this.onDescriptionChanged,
    required this.onEditLinkButtonPressed,
    required this.userNameController,
    required this.descriptionController,
    required this.croppedFile,
    required this.isLoading,
    required this.isCropped,
    required this.mainModel,
  }) : super(key: key);

  final void Function()? onCancelButtonPressed;
  final void Function()? onSaveButtonPressed;
  final void Function()? showImagePicker;
  final void Function()? onEditLinkButtonPressed;
  final void Function(String)? onUserNameChanged;
  final void Function(String)? onDescriptionChanged;
  final TextEditingController userNameController;
  final TextEditingController descriptionController;
  final File? croppedFile;
  final bool isLoading;
  final bool isCropped;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0
    );

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading ?
      Loading()
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: onCancelButtonPressed,
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
                  press: onSaveButtonPressed,
                  textColor: Colors.white, 
                  buttonColor: Theme.of(context).highlightColor
                )
              ],
            ),
            
            Row(
              children: [
                InkWell(
                  child: isCropped ?  CircleImage(length: 80.0, image: FileImage(croppedFile!) ) : UserImage(userImageURL: mainModel.currentWhisperUser.imageURL, length: 80.0, padding: 10.0),
                  onTap: showImagePicker,
                ),
                SizedBox(width: 16.0,),
                InkWell(
                  child: Icon(Icons.link),
                  onTap: onEditLinkButtonPressed
                )
              ],
            ),
            Text('名前',style: textStyle,),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: userNameController,
              onChanged: onUserNameChanged,
              style: textStyle
            ),
            Text('自己紹介',style: textStyle,),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              controller: descriptionController,
              onChanged: onDescriptionChanged,
              style: textStyle
            ),
          ],
        ),
      ),
    );
  }
}