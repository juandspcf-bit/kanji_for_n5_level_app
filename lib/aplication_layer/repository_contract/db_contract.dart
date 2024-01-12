import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

abstract class LocalDBService {
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(KanjiFromApi kanjiFromApi);
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi);
  Future<void> deleteUserData(String uuid);
}
