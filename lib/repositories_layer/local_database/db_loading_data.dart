import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

Future<List<KanjiFromApi>> loadStoredKanjisFromSqliteDB(String uuid) async {
  if (uuid == '') {
    return Future(() => []);
  }

  final db = await kanjiFromApiDatabase;
  final dataKanjiFromApi =
      await db.query('kanji_FromApi', where: 'uuid = ?', whereArgs: [uuid]);

  if (dataKanjiFromApi.isEmpty) return [];

  final List<KanjiFromApi> kanjisFromApi = [];

  for (final mapKanjiFromDb in dataKanjiFromApi) {
    final kanjiCharacter = mapKanjiFromDb['kanjiCharacter'] as String;
    final listMapExamplesFromDb = await db.rawQuery(
        'SELECT * FROM examples WHERE kanjiCharacter = ? AND uuid = ?',
        [kanjiCharacter, uuid]);

    final examples = listMapExamplesFromDb.map((exampleFromDb) {
      final audio = AudioExamples(mp3: exampleFromDb['mp3'] as String);
      final meaning = Meaning(english: exampleFromDb['meaning'] as String);
      return Example(
          japanese: exampleFromDb['japanese'] as String,
          meaning: meaning,
          audio: audio);
    }).toList();

    final listMapStrokesImagesLisnkFromDb = await db.rawQuery(
        'SELECT * FROM strokes WHERE kanjiCharacter = ? AND uuid = ?',
        [kanjiCharacter, uuid]);

    final listStrokesImagesLinks = listMapStrokesImagesLisnkFromDb
        .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
        .toList();

    final strokes = Strokes(
        count: listStrokesImagesLinks.length, images: listStrokesImagesLinks);

    final kanjiFromApi = KanjiFromApi(
      kanjiCharacter: mapKanjiFromDb['kanjiCharacter'] as String,
      englishMeaning: mapKanjiFromDb['englishMeaning'] as String,
      kanjiImageLink: mapKanjiFromDb['kanjiImageLink'] as String,
      katakanaRomaji: mapKanjiFromDb['katakanaRomaji'] as String,
      katakanaMeaning: mapKanjiFromDb['katakanaMeaning'] as String,
      hiraganaRomaji: mapKanjiFromDb['hiraganaRomaji'] as String,
      hiraganaMeaning: mapKanjiFromDb['hiraganaMeaning'] as String,
      videoLink: mapKanjiFromDb['videoLink'] as String,
      section: mapKanjiFromDb['section'] as int,
      accessToKanjiItemsButtons: true,
      statusStorage: StatusStorage.stored,
      example: examples,
      strokes: strokes,
    );

    kanjisFromApi.add(kanjiFromApi);
  }

  return kanjisFromApi;
}

Future<ImageDetailsLink> loadImageDetailsFromSqliteDB(
  String kanjiCharacter,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final imageDetailsDataList = await db.query('image_meaning',
      where: 'uuid = ? AND kanjiCharacter= ?',
      whereArgs: [uuid, kanjiCharacter],
      limit: 1);

  if (imageDetailsDataList.isEmpty) {
    return ImageDetailsLink(
      kanji: '',
      link: '',
      linkHeight: 0,
      linkWidth: 0,
    );
  }
  final imageDetailsData = imageDetailsDataList.first;
  return ImageDetailsLink(
    kanji: imageDetailsData['kanjiCharacter'] as String,
    link: imageDetailsData['link'] as String,
    linkHeight: imageDetailsData['linkHeight'] as int,
    linkWidth: imageDetailsData['linkWidth'] as int,
  );
}
