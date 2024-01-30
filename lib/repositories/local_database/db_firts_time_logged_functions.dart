import 'package:kanji_for_n5_level_app/models/first_time_logged.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';

Future<FirtsTimeLogged> loadFirtsTimeLoggedData(String uuid) async {
  final db = await kanjiFromApiDatabase;
  final listData = await db.rawQuery(
    'SELECT * FROM firts_logging_status '
    'WHERE uuid = ?',
    [uuid],
  );

  if (listData.isEmpty) {
    return FirtsTimeLogged(
      uuid: uuid,
      isFirstTimeLogged: null,
    );
  }

  final firtsEntry = listData.first;
  return FirtsTimeLogged(
    uuid: uuid,
    isFirstTimeLogged: (firtsEntry['isLogged'] as int) == 1,
  );
}

Future<int> insertFirtsTimeLogged(String uuid) async {
  const isLogged = true;
  final db = await kanjiFromApiDatabase;
  return await db.rawInsert(
    'INSERT INTO kanji_quiz('
    ' isLogged,'
    ' uuid'
    ') '
    'VALUES(?,?,?,?,?,?,?)',
    [isLogged, uuid],
  );
}
