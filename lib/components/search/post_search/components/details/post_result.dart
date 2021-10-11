// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';

class PostResult extends StatelessWidget {

  const PostResult({
    Key? key,
    required this.result,
    required this.i,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);
  
  final Map<String,dynamic> result;
  final int i;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;

  @override 
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () async {
        await postSearchModel.initAudioPlayer(i);
      },
      child: Container(
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
                leading: RedirectUserImage(userImageURL: result['userImageURL'], length: 50.0, padding: 0.0,passiveUserDocId: result['userDocId'],mainModel: mainModel,),
                title: Text(result['userName']),
                subtitle: Text(
                  result['title'],
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}