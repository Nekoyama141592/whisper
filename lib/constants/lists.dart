// constants
import 'package:flutter/material.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/l10n/l10n.dart';

const List<String> commonPasswords = [
  '12345',
  '123456',
  '123456789',
  'qwerty',
  'password',
  '12345678',
  '111111',
  '123123',
  '1234567890',
  '1234567',
  'qwerty123',
  '1q2w3e',
  'aa12345678',
  'abc123',
  'password1',
  '1234',
  'password123',
  '1qaz2wsx',
  'member',
  'asdfghjk',
  'asdfghjkl',
  'asdf1234',
  'qwertyuiop',
  'sakura',
  '1q2w3e4r',
  'qwer1234',
  'abcd1234',
  'zaq12wsx',
  'qwertyui'
];
const List<String> notUseOnField = ['.','[',']','*','`'];
List<String> reportContents({ required BuildContext context }) {
  final L10n l10n = returnL10n(context: context)!;
  return
  [
  l10n.containingSexualActs,
  l10n.nudity,
  l10n.suggestiveOfSexualActivity,
  l10n.contentConcerningMinors,
  l10n.inappropriateWordingInTitleOrDescription,
  l10n.violentActs,
  l10n.crueltyToAnimals,
  l10n.discriminationOrPromotionOfViolence,
  l10n.attacksOnVulnerablePeople,
  l10n.harassmentAgainstYourself,
  l10n.harassmentOfOtherUsers,
  l10n.substanceAbuseContent,
  l10n.suicideOrSelfHarm,
  l10n.otherDangerousBehaviour,
  l10n.childAbuse,
  l10n.promotionOfTerrorism,
  l10n.spam,
  l10n.pharmaceuticalRelatedContent,
  l10n.misleadingDescriptions,
  l10n.misleadingPictures,
  l10n.fraudOrDishonesty,
  l10n.copyrightIssues,
  l10n.privacyIssues,
  l10n.trademarkInfringement,
  l10n.defamation,
  l10n.counterfeitGoods,
  l10n.otherLegalIssues,
  l10n.sexualOrViolentIcons
];
}
List<String> returnSearchWords({ required String searchTerm }) {
  List<String> afterSplit =  searchTerm.split('');
  afterSplit.removeWhere((element) => notUseOnField.contains(element) );
  String result = '';
  afterSplit.forEach((element) { 
    final x = element.toLowerCase();
    result += x; 
  });
  // bi-gram
  final int length = result.length;
  List<String> searchWords = [];
  if (length < nGramIndex) {
    searchWords.add(result);
  } else {
    int termIndex = 0;
    for (int i = 0; i < length - nGramIndex + 1; i++) {
      final String word = result.substring(termIndex,termIndex + nGramIndex);
      searchWords.add(word);
      termIndex++;
    }
  }
  return searchWords;
}