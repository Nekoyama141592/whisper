
Map<String,dynamic> returnTokenToSearch({ required List<String> searchWords }) {
  Map<String,dynamic> tokenToSearch = {};
  searchWords.forEach((word) {
    tokenToSearch[word] = true;
  });
  return tokenToSearch;
}