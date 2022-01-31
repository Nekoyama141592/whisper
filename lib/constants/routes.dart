// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
// pages
import 'package:whisper/main.dart';
import 'package:whisper/links/links_page.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/auth/account/account_page.dart';
import 'package:whisper/nft_owners/nft_owners_page.dart';
import 'package:whisper/components/add_post/add_post_page.dart';
import 'package:whisper/auth/is_finished/is_finished_page.dart';
import 'package:whisper/auth/update_email/update_email_page.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/posts/components/replys/replys_page.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
import 'package:whisper/one_post/one_comment/one_comment_page.dart';
import 'package:whisper/important_matters/other_pages/tos_page.dart';
import 'package:whisper/posts/components/comments/comments_page.dart';
import 'package:whisper/important_matters/important_matters_page.dart';
import 'package:whisper/auth/update_password/update_password_page.dart';
import 'package:whisper/important_matters/other_pages/privacy_page.dart';
import 'package:whisper/auth/signup/other_pages/add_user_info_page.dart';
import 'package:whisper/auth/reauthentication/reauthentication_page.dart';
import 'package:whisper/components/notifications/notifications_page.dart';
import 'package:whisper/important_matters/other_pages/compliance_page.dart';
import 'package:whisper/components/add_post/other_pages/pick_post_image_page.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_page.dart';
import 'package:whisper/posts/components/other_pages/post_show/post_show_page.dart';
import 'package:whisper/auth/account/other_pages/blocks_users/blocks_users_page.dart';
import 'package:whisper/auth/login/verify_password_reset/verify_password_reset_page.dart';
// constants
import 'package:whisper/constants/enums.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/links/links_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/auth/signup/signup_model.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

void toMyApp(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}
void toLoginpage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void toSignupPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
}

void toAddUserInfoPage(context,SignupModel signupModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserInfoPage(signupModel: signupModel)));
}

void toVerifyPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPage()));
}
void toVerifyPasswordResetPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPasswordResetPage()));
}

void toUpdateEmailPage(context,User? currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEmailPage(currentUser: currentUser,)));
}
void toUpdatePassword({ required BuildContext context,required User? currentUser}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordPage(currentUser: currentUser )));
}
void toReauthenticationPage({required context, required User? currentUser, required AccountModel accountModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ReauthenticationPage(currentUser: currentUser,accountModel: accountModel,mainModel: mainModel,)));
}

void toBookmarksPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage(mainModel: mainModel) ));
}

void toPostShowPage({ required BuildContext context, required ValueNotifier<double> speedNotifier, required void Function()? speedControll, required ValueNotifier<Map<String,dynamic>> currentSongMapNotifier, required ProgressNotifier progressNotifier, required void Function(Duration)? seek, required RepeatButtonNotifier repeatButtonNotifier, required void Function()? onRepeatButtonPressed, required ValueNotifier<bool> isFirstSongNotifier, required void Function()? onPreviousSongButtonPressed, required PlayButtonNotifier playButtonNotifier, required void Function()? play, required void Function()? pause, required ValueNotifier<bool> isLastSongNotifier,void Function()? onNextSongButtonPressed,void Function()? toCommentsPage,void Function()? toEditingMode, required PostType postType,required MainModel mainModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>PostShowPage(speedNotifier: speedNotifier, speedControll: speedControll, currentSongMapNotifier: currentSongMapNotifier, progressNotifier: progressNotifier, seek: seek, repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode, postType: postType,mainModel: mainModel) ));
}

void toUserShowPage({ required BuildContext context, required WhisperUser passiveWhisperUser, required MainModel mainModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(passiveWhisperUser: passiveWhisperUser, mainModel: mainModel) ));
}

void toAccountPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(mainModel: mainModel,)));
}

void toNotificationsPage({ required BuildContext context, required MainModel mainModel, required ThemeModel themeModel, required LinksModel linksModel, required NotificationsModel notificationsModel,}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel: mainModel, themeModel: themeModel, linksModel: linksModel,notificationsModel: notificationsModel,) ));
}

void toAddPostPage ({ required BuildContext context, required AddPostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(mainModel: mainModel, addPostModel: addPostModel) ));
}

void toPickPostImagePage({ required BuildContext context, required AddPostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, mainModel: mainModel,) ));
}

void toCommentsPage(context,AudioPlayer audioPlayer,ValueNotifier<Map<String,dynamic>> currentSongMapNotifier,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(audioPlayer: audioPlayer, currentSongMap: currentSongMapNotifier.value, mainModel: mainModel) ));
}

void toReplysPage({ required BuildContext context, required ReplysModel replysModel, required Post whisperPost,required WhisperComment whisperComment, required MainModel mainModel  }) {
 Navigator.push(context, MaterialPageRoute(builder: (context) => ReplysPage(replysModel: replysModel, whisperPost: whisperPost, whisperComment: whisperComment, mainModel: mainModel) )); 
}

void toBlocksUsersPage(context, MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BlocksUsersPage(mainModel: mainModel,) ));
}

void toMutesUsersPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MutesUsersPage(mainModel: mainModel,) ));
}

void toIsFinishedPage({ required BuildContext context, required String title, required String text}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => IsFinishedPage(title: title, text: text,) ));
}

void toCompliancePage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CompliancePage() ));
}

void toPrivacyPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPage() ));
}

void toTosPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => TosPage() ));
}

void toImportantMattersPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ImportantMattersPage() ));
}

void toNFTownersPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NFTownersPage() ));
}

void toOneCommentPage ({ required BuildContext context, required MainModel mainModel} ) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => OneCommentPage(mainModel: mainModel,) ));
}

void toLinkPage({ required BuildContext context }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage() ) );
}

