// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/circle_image.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';

class EditProfileScreen extends StatelessWidget {
  
  const EditProfileScreen({
    Key? key,
    required this.onCancelButtonPressed,
    required this.onSaveButtonPressed,
    required this.showImagePicker,
    required this.onUserNameChanged,
    required this.userNameController,
    required this.bioController,
    required this.croppedFile,
    required this.isLoading,
    required this.isCropped,
    required this.mainModel,
  }) : super(key: key);

  final void Function()? onCancelButtonPressed;
  final void Function()? onSaveButtonPressed;
  final void Function()? showImagePicker;
  final void Function(String)? onUserNameChanged;
  final TextEditingController userNameController;
  final TextEditingController bioController;
  final File? croppedFile;
  final bool isLoading;
  final bool isCropped;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {

    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: defaultHeaderTextSize(context: context)
    );

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final L10n l10n = returnL10n(context: context)!;

    return Padding(
      padding: EdgeInsets.all(height/64.0),
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
                  child: boldText(text: cancelText(context: context)),
                ),
                Expanded(child: SizedBox()),
                RoundedButton(
                  text: l10n.save,
                  widthRate: 0.30, 
                  fontSize: defaultHeaderTextSize(context: context),
                  press: onSaveButtonPressed,
                  textColor: Colors.white, 
                  buttonColor: Theme.of(context).highlightColor
                )
              ],
            ),
            
            InkWell(
              child: isCropped ?  CircleImage(length: height/12.0, image: FileImage(croppedFile!) ) : UserImage(userImageURL: mainModel.currentWhisperUser.userImageURL, length: defaultPadding(context: context) * 3.0, padding: defaultPadding(context: context),uid: mainModel.currentWhisperUser.uid,mainModel: mainModel, ),
              onTap: showImagePicker,
            ),
            boldText(text: l10n.name),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: userNameController,
              onChanged: onUserNameChanged,
              style: textStyle
            ),
          ],
        ),
      ),
    );
  }
}