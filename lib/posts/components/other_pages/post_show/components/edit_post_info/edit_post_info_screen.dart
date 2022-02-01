// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/links/links_model.dart';
// model
import 'edit_post_info_model.dart';
import 'package:whisper/main_model.dart';


class EditPostInfoScreen extends StatelessWidget {

  const EditPostInfoScreen({
    Key? key,
    required this.mainModel,
    required this.currentSongMap,
    required this.editPostInfoModel,
    required this.linksModel
  }) : super(key: key);

  final MainModel mainModel;
  final Map<String,dynamic> currentSongMap;
  final EditPostInfoModel editPostInfoModel;
  final LinksModel linksModel;
  @override 
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    final whisperPost = fromMapToPost(postMap: currentSongMap);
    final postTitleController = TextEditingController(text: whisperPost.title );
    final String imageURL = whisperPost.imageURLs.first;
    final String userImageURL = whisperPost.userImageURL;
    final String resultURL = imageURL.isNotEmpty ? imageURL : userImageURL;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿の編集がキャンセルされました')));
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
                      verticalPadding: 10, 
                      horizontalPadding: 5, 
                      press: () async  {
                        await editPostInfoModel.updatePostInfo(currentSongMap: currentSongMap, mainModel: mainModel, context: context, linksModel: linksModel );
                      },
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
                SizedBox(height: 20.0),
                Row(
                  children: [
                    RoundedButton(
                      text: editPostInfoModel.isCropped ? '写真を変更する' :'投稿用の写真を編集',
                      widthRate: 0.45, 
                      verticalPadding: 20.0, 
                      horizontalPadding: 10.0, 
                      press: () async { editPostInfoModel.showImagePicker(); }, 
                      textColor: editPostInfoModel.isCropped ? Theme.of(context).focusColor : Colors.black, 
                      buttonColor: editPostInfoModel.isCropped ?  Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary
                    ),
                    SizedBox(width: 16.0,),
                    RoundedButton(
                      text: 'リンクを編集',
                      widthRate: 0.45, 
                      verticalPadding: 20.0, 
                      horizontalPadding: 10.0, 
                      press: () { linksModel.init(context: context, linkMaps: whisperPost.links ); }, 
                      textColor: editPostInfoModel.isCropped ? Theme.of(context).focusColor : Colors.black, 
                      buttonColor: editPostInfoModel.isCropped ?  Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  '投稿のタイトル',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                  ),
                  keyboardType: TextInputType.text,
                  controller: postTitleController,
                  onChanged: (text) {
                    whisperPost.title = text;
                  },
                  decoration: InputDecoration(
                    hintText: whisperPost.title,
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