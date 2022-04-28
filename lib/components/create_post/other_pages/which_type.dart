// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/create_post/create_post_model.dart';

class WhichType extends ConsumerWidget {

  WhichType({
    Key? key,
    required this.mainModel
  }) : super(key: key);
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final addPostModel = ref.watch(addPostProvider);
    return
    GradientScreen(
      top: SizedBox.shrink(),
      header: Padding(
        padding: EdgeInsets.all(defaultPadding(context: context)),
        child: whiteBoldEllipsisHeaderText(context: context,text: 'WhichType'),
      ),
      content: Content(mainModel: mainModel, addPostModel: addPostModel),
      circular: defaultHeaderTextSize(context: context),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    Key? key,
    required this.mainModel,
    required this.addPostModel
  }) : super(key: key);

  final MainModel mainModel;
  final CreatePostModel addPostModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final L10n l10n = returnL10n(context: context)!;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding(context: context)
        ),
        child: Container(
          
          child: Column(
            
            children: [
              SvgPicture.asset(
                'assets/svgs/business_decisions-pana.svg',
                height: size.height * 0.3,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultPadding(context: context),
                ),
                child: boldEllipsisText(text: whichTypeText),
              ),
              RoundedButton(
                text: l10n.postingOfAdvertisements,
                widthRate: 0.8,
                fontSize: defaultHeaderTextSize(context: context),
                press: () => showBasicFlutterToast(context: context, msg: l10n.toBeImplemented ),
                textColor: Colors.black, 
                buttonColor: Theme.of(context).colorScheme.secondary
              ),
              RoundedButton(
                text: l10n.commonPost,
                widthRate: 0.8,
                fontSize: defaultHeaderTextSize(context: context),
                press: () => routes.toAddPostPage(context: context, addPostModel: addPostModel, mainModel: mainModel),
                textColor: Colors.white, 
                buttonColor: Theme.of(context).highlightColor
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}