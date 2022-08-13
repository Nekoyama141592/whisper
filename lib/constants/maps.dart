Map<String,dynamic> returnSearchToken({ required List<String> searchWords }) {
  Map<String,dynamic> searchToken = {};
  searchWords.forEach((word) {
    searchToken[word] = true;
  });
  return searchToken;
}