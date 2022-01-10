// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/others.dart';
// model
import 'package:whisper/main_model.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
    required this.result,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> result;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    final passiveWhisperUser = fromMapToWhisperUser(userMap: result);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).focusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              // result['objectID']も可
              leading: RedirectUserImage(userImageURL: passiveWhisperUser.imageURL, length: 50.0, padding: 0.0,passiveUserDocId: passiveWhisperUser.uid,mainModel: mainModel,),
              title: Text(
                passiveWhisperUser.userName,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20.0
                ),
              ),
              subtitle: Text(
                passiveWhisperUser.description,
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}