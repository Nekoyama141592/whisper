import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:whisper/constants/colors.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/parts/components/rounded_button.dart';
import 'package:whisper/add_post/components/add_post_screen/add_post_screen.dart';

class WhichType extends StatelessWidget {

  final DocumentSnapshot currentUserDoc;
  WhichType(this.currentUserDoc);
  @override 
  Widget build(BuildContext context) {
    
    return
    AddPostScreen(currentUserDoc, Content(currentUserDoc: currentUserDoc,));
  }
}

class Content extends StatelessWidget {
  const Content({
    Key? key,
    required this.currentUserDoc,
  }) : super(key: key);

  final DocumentSnapshot<Object?> currentUserDoc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      
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
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('実装予定です！')
                    )
                  );
                }, 
                Colors.black, 
                kQuaternaryColor
              ),
              RoundedButton(
                '普通の投稿', 
                0.8,
                () {
                  routes.toAddPostPage(context, currentUserDoc);
                }, 
                Colors.white, 
                kTertiaryColor
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}