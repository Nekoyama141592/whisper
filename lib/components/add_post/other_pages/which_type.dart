// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/details/gradient_screen.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

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
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'WhichType',
          style: TextStyle(
            fontSize: defaultHeaderTextSize(context: context),
            fontWeight: FontWeight.bold
          ),
        ),
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
  final AddPostModel addPostModel;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                child: Text(
                  'Which type?',
                  style: TextStyle(
                    fontSize: defaultHeaderTextSize(context: context),
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              RoundedButton(
                text: '広告の投稿',
                widthRate: 0.8,
                verticalPadding: defaultPadding(context: context),
                horizontalPadding: defaultPadding(context: context),
                press: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('実装予定です！')
                    )
                  );
                }, 
                textColor: Colors.black, 
                buttonColor: Theme.of(context).colorScheme.secondary
              ),
              RoundedButton(
                text: '普通の投稿', 
                widthRate: 0.8,
                verticalPadding: defaultPadding(context: context),
                horizontalPadding: defaultPadding(context: context),
                press: () {
                  routes.toAddPostPage(context: context, addPostModel: addPostModel, mainModel: mainModel);
                }, 
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