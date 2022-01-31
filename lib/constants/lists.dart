// constants
import 'package:whisper/constants/ints.dart';

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
final List<String> notUseOnField = ['.','[',']','*','`'];
List<String> returnSearchWords({ required String searchTerm }) {
  final int length = searchTerm.length;
  List<String> searchWords = [];
  if (length < nGramIndex) {
    searchWords.add(searchTerm);
  } else {
    int termIndex = 0;
    for (int i = 0; i < length - nGramIndex + 1; i++) {
      final String word = searchTerm.substring(termIndex,termIndex + nGramIndex);
      searchWords.add(word);
      termIndex++;
    }
  }
  return searchWords;
}