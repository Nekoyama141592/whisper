// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/views/auth/account/components/user_cards.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/auth/mutes_users_model.dart';

class MutesUsersPage extends ConsumerWidget {

  const MutesUsersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref) {

    final muteUsersModel = ref.watch(muteUsersProvider);
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      appBar: AppBar(
        title: whiteBoldEllipsisHeaderText(context: context, text: l10n.muteUsers)
      ),
      body: UserCards(
        userDocs: muteUsersModel.userDocs, 
        mainModel: mainModel,
        muteUsersModel: muteUsersModel,
        onLoading: () async => await muteUsersModel.onLoading(),
        onReload: () async => await muteUsersModel.onReload(),
        onRefresh: () async => await muteUsersModel.onRefresh(mainModel: mainModel),
        refreshController: muteUsersModel.refreshController,
      )
    );
  }
}