import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

abstract class KanjiApiService {
  Future<List<KanjiFromApi>> requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacters,
    int section,
    String uuid,
  );

  Future<KanjiFromApi> requestSingleKanjiToApi(
    String kanjisCharacters,
    int section,
  );

  Future<KanjiFromApi> getKanjiFromEnglishWord(String word, String uuid);

  Future<List<String>> getKanjisByGrade(int grade);

  Future<KanjiFromApi> getTranslatedKanjiFromSpanishWord(
    String word,
    String uuid,
  );
}

class TranslationException implements Exception {
  final String message;

  const TranslationException(this.message);

  @override
  String toString() => message;
}

class KanjiFetchingException implements Exception {
  final String message;

  const KanjiFetchingException(this.message);

  @override
  String toString() => message;
}
