import 'package:injectable/injectable.dart';
import 'package:translator/translator.dart';

@lazySingleton
class TranslationService {
  final _translator = GoogleTranslator();

  Future<String> translate(String text, {String to = 'pl'}) async {
    if (text.isEmpty) return text;
    try {
      final translation = await _translator.translate(text, to: to);
      return translation.text;
    } catch (e) {
      // Return original text on error
      return text;
    }
  }
}
