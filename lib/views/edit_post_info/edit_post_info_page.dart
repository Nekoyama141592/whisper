// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/details/positive_text.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import '../../models/edit_post_info/edit_post_info_model.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';

class EditPostInfoScreen extends StatelessWidget {

  const EditPostInfoScreen({
    Key? key,
    required this.mainModel,
    required this.currentWhisperPost,
    required this.editPostInfoModel,
  }) : super(key: key);

  final MainModel mainModel;
  final Post currentWhisperPost;
  final EditPostInfoModel editPostInfoModel;
  @override 
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    final postTitleController = TextEditingController(text: editPostInfoModel.title );
    final String imageURL = currentWhisperPost.imageURLs.first;
    final String userImageURL = currentWhisperPost.userImageURL;
    final String resultURL = imageURL.isNotEmpty ? imageURL : userImageURL;
    final height = size.height;
    final L10n l10n = returnL10n(context: context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        editPostInfoModel.isEditing = false;
                        editPostInfoModel.reload();
                        showBasicFlutterToast(context: context, msg: l10n.cancelEditPostInfo );
                      }, 
                      child: PositiveText(text: cancelText(context: context)),
                    ),
                    Expanded(child: SizedBox()),
                    RoundedButton(
                      text: l10n.save,
                      widthRate: 0.25, 
                      fontSize: defaultHeaderTextSize(context: context),
                      press: () async  => await editPostInfoModel.updatePostInfo(whisperPost: currentWhisperPost, mainModel: mainModel, context: context,),
                      textColor: Colors.white, 
                      buttonColor: Theme.of(context).highlightColor
                    )
                  ],
                ),
                !editPostInfoModel.isCropped ?
                Container(
                  width: length,
                  height: length,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).highlightColor
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(resultURL),
                    )
                  ),
                ) 
                : SizedBox(width: length,height: length,child: Image.file(editPostInfoModel.croppedFile!)),
                SizedBox(height: defaultPadding(context: context) ),
                Row(
                  children: [
                    RoundedButton(
                      text: l10n.image,
                      widthRate: 0.45, 
                      fontSize: defaultHeaderTextSize(context: context), 
                      press: () async => editPostInfoModel.showImagePicker(),
                      textColor: editPostInfoModel.isCropped ? Theme.of(context).focusColor : Colors.black, 
                      buttonColor: editPostInfoModel.isCropped ?  Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary
                    ),
                    SizedBox(width: defaultPadding(context: context),),
                    RoundedButton(
                      text: l10n.link,
                      widthRate: 0.45, 
                      fontSize: defaultHeaderTextSize(context: context),
                      press: () => editPostInfoModel.init(context: context, linkMaps: currentWhisperPost.links, ),
                      textColor: editPostInfoModel.isCropped ? Theme.of(context).focusColor : Colors.black, 
                      buttonColor: editPostInfoModel.isCropped ?  Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary
                    ),
                  ],
                ),
                SizedBox(height: height/64.0 ),
                boldEllipsisText(text: l10n.title),
                TextFormField(
                  style: boldEllipsisStyle(),
                  keyboardType: TextInputType.text,
                  controller: postTitleController,
                  onChanged: (text) => editPostInfoModel.title = text,
                  decoration: InputDecoration(
                    hintText: currentWhisperPost.title,
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}