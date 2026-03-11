// Taken from https://pub.dev/documentation/recase)
// Consider linking that package directly.

/// Convert strings like "British-music" into britishMusic
String lowerCamelCase(text, {String separator = ''}) {
  var result = camelCase(text, separator: separator);
  result = "${result[0].toLowerCase()}${result.substring(1)}";
  return result;
}

/// Convert strings like "light-light" into lightLight
String camelCase(text, {String separator = ''}) {
  final _words = _groupIntoWords(text);

  List<String> words = _words.map(_upperCaseFirstLetter).toList();

  if (_words.isNotEmpty) {
    words[0] = words[0].toLowerCase();
  }

  return words.join(separator);
}

String _upperCaseFirstLetter(String word) {
  return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
}

List<String> _groupIntoWords(String text) {
  StringBuffer sb = StringBuffer();
  List<String> words = [];
  bool isAllCaps = text.toUpperCase() == text;

  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    String? nextChar = i + 1 == text.length ? null : text[i + 1];

    if (symbolSet.contains(char)) {
      continue;
    }

    sb.write(char);

    bool isEndOfWord = nextChar == null ||
        (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
        symbolSet.contains(nextChar);

    if (isEndOfWord) {
      words.add(sb.toString());
      sb.clear();
    }
  }

  return words;
}

final symbolSet = {' ', '.', '/', '_', '\\', '-'};

final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
