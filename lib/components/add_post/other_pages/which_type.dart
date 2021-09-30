// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/add_post/components/add_post_screen/add_post_screen.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

class WhichType extends ConsumerWidget {

  WhichType({
    Key? key,
    required this.currentUserDoc
  }) : super(key: key);
  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final addPostModel = watch(addPostProvider);
    return
    AddPostScreen(
      top: SizedBox(height: 16,),
      content: Content(currentUserDoc: currentUserDoc, addPostModel: addPostModel,), 
      addPostModel: addPostModel, 
      currentUserDoc: currentUserDoc
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    Key? key,
    required this.currentUserDoc,
    required this.addPostModel
  }) : super(key: key);

  final DocumentSnapshot<Object?> currentUserDoc;
  final AddPostModel addPostModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10
        ),
        child: Container(
          
          child: Column(
            
            children: [
              SvgPicture.asset(
                'assets/svgs/business_decisions-pana.svg',
                height: size.height * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20
                ),
                child: Text(
                  'Which type?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              RoundedButton(
                '広告の投稿',
                0.8,
                20,
                10,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('実装予定です！')
                    )
                  );
                }, 
                Colors.black, 
                Theme.of(context).colorScheme.secondary
              ),
              RoundedButton(
                '普通の投稿', 
                0.8,
                20,
                10,
                () {
                  routes.toAddPostPage(context, addPostModel,currentUserDoc);
                }, 
                Colors.white, 
                Theme.of(context).highlightColor
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}