import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/first_time_logged.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';

Future<FirstTimeLogged> loadFirstTimeLoggedData(String uuid) async {
  try {
    final db = await kanjiFromApiDatabase;
    final listData = await db.rawQuery(
      'SELECT * FROM first_logging_status '
      'WHERE uuid = ?',
      [uuid],
    );

    if (listData.isEmpty) {
      return FirstTimeLogged(
        uuid: uuid,
        isFirstTimeLogged: null,
      );
    }

    final firstEntry = listData.first;
    return FirstTimeLogged(
      uuid: uuid,
      isFirstTimeLogged: (firstEntry['isLogged'] as int) == 1,
    );
  } catch (e) {
    logger.e(e);
    return FirstTimeLogged(
      uuid: uuid,
      isFirstTimeLogged: null,
    );
  }
}

Future<int> insertFirstTimeLogged(String uuid) async {
  const isLogged = true;
  final db = await kanjiFromApiDatabase;
  return await db.rawInsert(
    'INSERT INTO first_logging_status('
    ' isLogged,'
    ' uuid'
    ') '
    'VALUES(?,?)',
    [isLogged, uuid],
  );
}
