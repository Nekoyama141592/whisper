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
const List<String> notUseOnField = ['.','[',']','*','`'];
const List<String> reportContents = [
  '性的行為を含む',
  'ヌード',
  '性的行為を連想させる',
  '未成年者に関するコンテンツ',
  'タイトルまたは説明の表現が不適切',
  '暴力行為',
  '未成年の暴力',
  '動物の虐待',
  '差別や暴力の助長',
  '弱者に対する攻撃',
  '自分に対する嫌がらせ',
  '他のユーザーに対する嫌がらせ',
  '薬物乱用のコンテンツ',
  '自殺または自傷行為',
  'その他の危険な行為',
  '児童虐待',
  'テロリズムの助長',
  'スパム',
  '医薬品関係の内容',
  '誤解を招く説明',
  '誤解を招く写真',
  '詐欺、または不正行為',
  '著作権の問題',
  'プライバシーの問題',
  '商標権侵害',
  '名誉毀損',
  '偽造品',
  'その他の法的問題'
];
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