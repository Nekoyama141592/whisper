// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';

class UserResult extends StatelessWidget {

  const UserResult({
    Key? key,
    required this.result,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> result;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor.withOpacity(0.3),
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
              leading: RedirectUserImage(userImageURL: result['userImageURL'], length: 50.0, padding: 0.0,passiveUserDocId: result['objectID'],mainModel: mainModel,),
              title: Text(result['userName']),
              subtitle: Text(
                result['description'],
              ),
            )
          ],
        ),
      ),
    );
  }
}