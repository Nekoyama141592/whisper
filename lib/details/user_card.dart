// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/strings.dart';
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
    final followersCount = result[followersCountKey];
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
              leading: RedirectUserImage(userImageURL: result[imageURLKey], length: 50.0, padding: 0.0,passiveUserDocId: result[uidKey],mainModel: mainModel,),
              title: Text(
                result[userNameKey],
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 20.0
                ),
              ),
              subtitle: Text(
                result[descriptionKey],
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Text(
                followersCount >= 10000 ? (followersCount/1000.floor()/10).toString() + '万' :  followersCount.toString(),
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
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