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
    String uuid,
  );

  Future<void> getKanjiFromEnglishWord(
      String word,
      void Function(List<KanjiFromApi>) onSuccess,
      void Function() onError,
      String uuid);
}
