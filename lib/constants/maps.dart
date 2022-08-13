Map<String,dynamic> returnSearchToken({ required List<String> searchWords }) {
  Map<String,dynamic> searchToken = {};
  for (final word in searchWords) searchToken[word] = true;
  return searchToken;
}