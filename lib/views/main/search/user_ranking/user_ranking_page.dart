// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/details/user_card.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/l10n/l10n.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/user_ranking_model.dart';

class UserRankingPage extends ConsumerWidget {
  
  const UserRankingPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final userRankingModel = ref.watch(userRankingProvider);
    final L10n l10n = returnL10n(context: context)!;
    return GradientScreen(
        top: SizedBox.shrink(), 
        header: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: whiteBoldEllipsisHeaderText(context: context, text: 'User Ranking'),
        ),
      circular: defaultPadding(context: context),
      child: RefreshScreen(
        isEmpty: userRankingModel.userDocs.isEmpty,
        subWidget: SizedBox.shrink(),
        controller: userRankingModel.refreshController,
        // TODO: onRefresh: () async => await userRankingModel.onRefresh(),
        // TODO: onReload: () async => await userRankingModel.onReload(),
        onLoading: () async => await userRankingModel.onLoading(),
        onRefresh: () {},
        onReload: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding(context: context)
          ),
          child: ListView.builder(
            itemCount: userRankingModel.userDocs.length,
            itemBuilder: (BuildContext context, int i) {
              final DocumentSnapshot<Map<String,dynamic>> userDoc = userRankingModel.userDocs[i];
              final WhisperUser whisperUser = fromMapToWhisperUser(userMap: userDoc.data()!);
              return mainModel.muteUids.contains(whisperUser.uid) || mainModel.blockUids.contains(whisperUser.uid) ?
              ListTile(
                title: boldEllipsisText(text: l10n.hidden),
                leading: Icon(Icons.block),
              )
              : UserCard(result: userDoc.data()!, mainModel: mainModel);
            }
          ),
        ),
      ), 
    );
  }
}