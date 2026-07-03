/// Capitalizes the first letter of [text], leaving the rest untouched.
/// Handles multi-byte/unicode first characters correctly via runes.
String capitalizeFirst(String text) {
  if (text.isEmpty) return text;
  final runes = text.runes.toList();
  final first = String.fromCharCode(runes.first).toUpperCase();
  final rest = String.fromCharCodes(runes.skip(1));
  return '$first$rest';
}
