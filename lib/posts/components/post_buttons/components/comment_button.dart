// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/posts/components/comments/comments_model.dart';

class CommentButton extends ConsumerWidget {

  CommentButton({
    Key? key,
    required this.currentSongDocNotifier,
    required this.currentUserDoc
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final DocumentSnapshot currentUserDoc;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    final commentEditingController = TextEditingController();

    return 
    IconButton(
      onPressed: () { routes.toCommentsPage(context, currentSongDocNotifier,currentUserDoc); }, 
      icon: Icon(Icons.comment)
    );
  //   IconButton(
  //     icon: Icon(Icons.comment),
  //     onPressed: () {
  //       showDialog(
  //         context: context, 
  //         builder: (_) {
  //           return AlertDialog(
  //             title: Text('comment'),
  //             content: SingleChildScrollView(
  //               child: ListBody(
  //                 children: [
  //                   Container(
  //                     child: TextField(
  //                       controller: commentEditingController,
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: 10,
  //                       decoration: InputDecoration(
  //                         border: OutlineInputBorder(),
  //                       ),
  //                       onChanged: (text) {
  //                         commentsModel.comment = text;
  //                       },
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: Text('cancel'),
  //                 onPressed: (){
  //                   Navigator.pop(context);
  //                 }, 
  //               ),
  //               ElevatedButton(
  //                 child: Text('送信'),
  //                 onPressed: ()async {
  //                   await commentsModel.makeComment(currentSongDoc);
  //                 }, 
  //               )
  //             ],
  //           );
  //         }
  //       );
  //     }, 
  //   );
  }
}