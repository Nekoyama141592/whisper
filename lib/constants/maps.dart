Map<String,dynamic> returnSearchToken({ required List<String> searchWords }) {
  Map<String,dynamic> tokenToSearch = {};
  searchWords.forEach((word) {
    tokenToSearch[word] = true;
  });
  return tokenToSearch;
}