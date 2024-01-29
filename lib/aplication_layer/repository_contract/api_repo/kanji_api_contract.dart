import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

abstract class KanjiApiService {
  Future<List<KanjiFromApi>> requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
  );
}
