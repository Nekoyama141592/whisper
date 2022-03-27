// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/components/user_show/components/other_pages/show_bio/show_bio_model.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/details/rounded_button.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'package:whisper/main_model.dart';

class ShowDescriptionPage extends ConsumerWidget {

  const ShowDescriptionPage({
    Key? key,
    required this.passiveWhisperUser,
    required this.mainModel
  }) : super(key: key);
  
  final WhisperUser passiveWhisperUser;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref) {
    
    final textStyle = TextStyle(
      fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2,
      fontWeight: FontWeight.bold
    );
    final bioController = TextEditingController(text: passiveWhisperUser.bio);
    final ShowBioModel showBioModel = ref.watch(showBioProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('自己紹介'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(defaultPadding(context: context) )
          )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(defaultPadding(context: context)),
        child: mainModel.userMeta.uid == passiveWhisperUser.uid ?
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              controller: bioController,
              onChanged: (text) {
                showBioModel.bio = text;
              },
              style: textStyle
            ),
            Center(
              child: RoundedButton(text: '更新', fontSize: defaultHeaderTextSize(context: context), widthRate: 0.95, press: () async {
                await showBioModel.updateBio(context: context, updateWhisperUser: mainModel.currentWhisperUser);
              }, textColor: Colors.white, buttonColor: Theme.of(context).highlightColor ),
            ),
            SizedBox()
          ],
        ) :
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(passiveWhisperUser.bio,style: textStyle)
            ],
          ),
        ),
      ),
    );
  }
}