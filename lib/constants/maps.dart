// constants
import 'package:whisper/constants/ints.dart';

Map<String,dynamic> tokenToSearch({ required String searchTerm }) {
  final int length = searchTerm.length;
  Map<String,dynamic> tokenToSearch = {};
  if (length < nGramIndex) {
    tokenToSearch[searchTerm] = true;
  } else {
    int termIndex = 0;
    for (int i = 0; i < length - nGramIndex + 1; i++) {
      final String key = searchTerm.substring(termIndex,termIndex + nGramIndex);
      tokenToSearch[key] = true;
      termIndex++;
    }
  }
  return tokenToSearch;
}