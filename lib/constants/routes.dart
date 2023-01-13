// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/models/post_search/post_search_model.dart';
// pages
import 'package:whisper/main.dart';
import 'package:whisper/views/auth/login/login_page.dart';
import 'package:whisper/views/auth/signup/signup_page.dart';
import 'package:whisper/views/auth/verify/verify_page.dart';
import 'package:whisper/views/auth/account/account_page.dart';
import 'package:whisper/views/nft_owners/nft_owners_page.dart';
import 'package:whisper/views/create_post/create_post_page.dart';
import 'package:whisper/views/auth/is_finished/is_finished_page.dart';
import 'package:whisper/views/auth/update_email/update_email_page.dart';
import 'package:whisper/views/replies/replies_page.dart';
import 'package:whisper/views/main/user_show/user_show_page.dart';
import 'package:whisper/views/one_comment/one_comment_page.dart';
import 'package:whisper/views/comments/comments_page.dart';
import 'package:whisper/views/auth/update_password/update_password_page.dart';
import 'package:whisper/views/auth/add_user_info/add_user_info_page.dart';
import 'package:whisper/views/auth/reauthentication/reauthentication_page.dart';
import 'package:whisper/views/main/notifications/notifications_page.dart';
import 'package:whisper/views/pick_post_image/pick_post_image_page.dart';
import 'package:whisper/views/auth/account/mutes_users_page.dart';
import 'package:whisper/views/post_show_page/post_show_page.dart';
import 'package:whisper/views/auth/verify_password_reset/verify_password_reset_page.dart';
import 'package:whisper/views/post_search/post_search_page.dart';
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
import 'package:whisper/models/themes/themes_model.dart';
import 'package:whisper/models/auth/signup_model.dart';
import 'package:whisper/models/auth/account_model.dart';
import 'package:whisper/models/main/create_post_model.dart';
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
  Navigator.push(context, MaterialPageRoute(builder: (context) => PostShowPage(speedNotifier: speedNotifier, speedControll: speedControll, currentWhisperPostNotifier: currentWhisperPostNotifier, progressNotifier: progressNotifier, seek: seek, repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode,postType: postType,mainModel: mainModel) ));
}

void toUserShowPage({ required BuildContext context, required MainModel mainModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage( mainModel: mainModel) ));
}

void toAccountPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(mainModel: mainModel,)));
}

void toNotificationsPage({ required BuildContext context, required MainModel mainModel, required ThemeModel themeModel}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel: mainModel, themeModel: themeModel) ));
}

void toAddPostPage ({ required BuildContext context, required CreatePostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage(mainModel: mainModel, addPostModel: addPostModel) ));
}

void toPickPostImagePage({ required BuildContext context, required CreatePostModel addPostModel, required MainModel mainModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, mainModel: mainModel,) ));
}

void toCommentsPage({ required BuildContext context, required AudioPlayer audioPlayer, required ValueNotifier<Post?> currentWhisperPostNotifier, required MainModel mainModel,required CommentsOrReplysModel commentsOrReplysModel }) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(audioPlayer: audioPlayer, whisperPost: currentWhisperPostNotifier.value!, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  ) ));
}

void toReplysPage({ required BuildContext context, required Post whisperPost,required WhisperPostComment whisperPostComment, required MainModel mainModel,required CommentsOrReplysModel commentsOrReplysModel}) {
 Navigator.push(context, MaterialPageRoute(builder: (context) => ReplysPage( whisperPost: whisperPost, whisperPostComment: whisperPostComment, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel,  ) )); 
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



