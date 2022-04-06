// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReportPostButton extends StatelessWidget {

  const ReportPostButton({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext) builder;

  @override 
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.flag_circle),
      onTap: () => showCupertinoModalPopup(
        context: context, 
        builder: builder
        // (innerContext) {
        //   return CupertinoActionSheet(
        //     actions: [
        //       CupertinoActionSheetAction(onPressed: () async {
        //         Navigator.pop(innerContext);
        //         await postFutures.muteUser(context: context, audioPlayer: audioPlayer, afterUris: afterUris, mutesUids: mutesUids, i: i, results: results, muteUsers: muteUsers, post: post, mainModel: mainModel);
        //       }, child: PositiveText(text: muteUserJaText) ),
        //       CupertinoActionSheetAction(onPressed: () async {
        //         Navigator.pop(innerContext);
        //         await postFutures.mutePost(context: context, mainModel: mainModel, i: i, post: post, afterUris: afterUris, audioPlayer: audioPlayer, results: results);
        //       }, child: PositiveText(text: mutePostJaText) ),
        //       CupertinoActionSheetAction(onPressed: () async {
        //         Navigator.pop(innerContext);
        //         postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: post, afterUris: afterUris, audioPlayer: audioPlayer, results: results);
        //       }, child: PositiveText(text: reportPostJaText) ),
        //       CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText) ),
        //     ],
        //   );
        // }
      )
    );
  }
}