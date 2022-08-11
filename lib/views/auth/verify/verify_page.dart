// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
// model
import 'package:whisper/models/auth/verify_model.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';

class VerifyPage extends ConsumerWidget {

  const VerifyPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final size = MediaQuery.of(context).size;
    final verifyModel = ref.watch(verifyProvider);
    String userEmail = verifyModel.currentUser!.email.toString();
    final L10n l10n = returnL10n(context: context)!;
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(defaultPadding(context: context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: defaultPadding(context: context)),
              child: SvgPicture.asset(
                'assets/svgs/key-pana.svg',
                height: size.height * 0.30,
              ),
            ),
            SizedBox(height: defaultPadding(context: context)),
            boldText(text: l10n.pleaseVerifyEmail(userEmail)),
            SizedBox(height: defaultPadding(context: context)),
            boldText(text: l10n.emailVerified),
            SizedBox(height: defaultPadding(context: context)),
            RoundedButton(
              text: l10n.start, 
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await verifyModel.onButtonPressed(context: context),
              textColor: Colors.white,
              buttonColor: Theme.of(context).highlightColor,
            ),
            
          ],
        ),
      ),
    );
  }
}