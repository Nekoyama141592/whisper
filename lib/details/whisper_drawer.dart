// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class WhisperDrawer extends StatelessWidget {
  
  WhisperDrawer({
    Key? key,
    required this.mainModel,
    required this.themeModel,
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;
  
  @override  
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          ListTile(
            title: boldText(text: l10n.account),
            onTap: () => routes.toAccountPage(context, mainModel)
          ),
          ListTile(
            title: boldText(text: l10n.themeChange),
            trailing: CupertinoSwitch(
              value: themeModel.isDarkTheme, 
              onChanged: (value) => themeModel.setIsDartTheme(value),
            ),
          ),
          
          ListTile(
            title: boldText(text: l10n.nftOwners),
            onTap: () => routes.toNFTownersPage(context),
          ),
          
        ],
      ),
    );
  }
}