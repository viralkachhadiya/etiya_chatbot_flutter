extension CheckHTMLExist on String {
  bool get containsHTML {
    return contains(RegExp(r'<\/?[a-z][\s\S]*>'));
  }
}