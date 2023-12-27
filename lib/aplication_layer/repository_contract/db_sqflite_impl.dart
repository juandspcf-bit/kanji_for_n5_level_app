import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';

class AppAplicationDBService implements ApplicationDBService {
  @override
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
      KanjiFromApi kanjiFromApi) async {
    return await storeKanjiToSqlDB(kanjiFromApi);
  }

  @override
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi) async {
    return await deleteKanjiFromSqlDB(kanjiFromApi);
  }
}
