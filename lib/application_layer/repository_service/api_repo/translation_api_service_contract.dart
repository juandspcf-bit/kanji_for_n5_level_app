import 'package:kanji_for_n5_level_app/models/translated_text.dart';

abstract class TranslationApiService {
  Future<TranslatedText> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  );
}
