// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/main_model.dart';
// model
import 'add_post_model.dart';
import 'package:whisper/components/add_post/components/add_post_content/add_post_content.dart';

class AddPostPage extends StatelessWidget {

  AddPostPage({
    Key? key,
    required this.mainModel,
    required this.addPostModel
  }) : super(key: key);

  final MainModel mainModel;
  final AddPostModel addPostModel;
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: GradientScreen(
        top: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: Theme.of(context).focusColor,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }, 
              ),
            ),
          ],
        ),
        header: Padding(
          padding: EdgeInsets.all(height/75.0),
          child: Text(
            '投稿する',
            style: TextStyle(
              fontSize: height/25.0,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        content: AddPostContent(addPostModel: addPostModel, mainModel: mainModel),
        circular: height/32.0,
      ),
    );
  }
}
