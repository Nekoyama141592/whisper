// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// pages
import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/auth/account/account_page.dart';
import 'package:whisper/nft_owners/nft_owners_page.dart';
import 'package:whisper/components/add_post/add_post_page.dart';
import 'package:whisper/auth/is_finished/is_finished_page.dart';
import 'package:whisper/auth/update_email/update_email_page.dart';
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
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_page.dart';
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
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/auth/signup/signup_model.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

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


void toPostShowPage({ required BuildContext context, required ValueNotifier<double> speedNotifier, required void Function()? speedControll, required ValueNotifier<Post?> currentWhisperPostNotifier, required ProgressNotifier progressNotifier, required void Function(Duration)? seek, required RepeatButtonNotifier repeatButtonNotifier, required void Function()? onRepeatButtonPressed, required ValueNotifier<bool> isFirstSongNotifier, required void Function()? onPreviousSongButtonPressed, required PlayButtonNotifier playButtonNotifier, required void Function()? play, required void Function()? pause, required ValueNotifier<bool> isLastSongNotifier,void Function()? onNextSongButtonPressed,void Function()? toCommentsPage,void Function()? toEditingMode, required PostType postType,required MainModel mainModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>PostShowPage(speedNotifier: speedNotifier, speedControll: speedControll, currentWhisperPostNotifier: currentWhisperPostNotifier, progressNotifier: progressNotifier, seek: seek, repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode, postType: postType,mainModel: mainModel) ));
}

void toUserShowPage({ required BuildContext context, required MainModel mainModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage( mainModel: mainModel) ));
}

void toAccountPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(mainModel: mainModel,)));
}

void toNotificationsPage({ required BuildContext context, required MainModel mainModel, required ThemeModel themeModel, required NotificationsModel notificationsModel,}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel: mainModel, themeModel: themeModel,notificationsModel: notificationsModel,) ));
}

void toAddPostPage ({ required BuildContext context, required AddPostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(mainModel: mainModel, addPostModel: addPostModel) ));
}

void toPickPostImagePage({ required BuildContext context, required AddPostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, mainModel: mainModel,) ));
}

void toCommentsPage({ required BuildContext context, required AudioPlayer audioPlayer, required ValueNotifier<Post?> currentWhisperPostNotifier, required MainModel mainModel,required CommentsOrReplysModel commentsOrReplysModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(audioPlayer: audioPlayer, whisperPost: currentWhisperPostNotifier.value!, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  ) ));
}

void toReplysPage({ required BuildContext context, required RepliesModel replysModel, required Post whisperPost,required WhisperPostComment whisperComment, required MainModel mainModel,required CommentsOrReplysModel commentsOrReplysModel}) {
 Navigator.push(context, MaterialPageRoute(builder: (context) => ReplysPage(replysModel: replysModel, whisperPost: whisperPost, whisperPostComment: whisperComment, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  ) )); 
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

void toNFTownersPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NFTownersPage() ));
}

void toOneCommentPage ({ required BuildContext context, required MainModel mainModel} ) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => OneCommentPage(mainModel: mainModel,) ));
}

void toPostSearchPage ({ required BuildContext context,required WhisperUser passiveWhisperUser,required MainModel mainModel, required PostSearchModel postSearchModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PostSearchPage(passiveWhisperUser: passiveWhisperUser, mainModel: mainModel, postSearchModel: postSearchModel) ) );
}



