import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:path_provider/path_provider.dart';

const durationTimeOutMili = 1000 * 60 * 5;

Future<void> insertUserDataToSqlite(Map<String, Object> data) async {
  final db = await kanjiFromApiDatabase;

  final listUserData = await readUserDataFromSqlite(data['uuid'] as String);

  if (listUserData.isEmpty) {
    await db.rawInsert(
      'INSERT INTO user_data('
      ' uuid,'
      ' fullName,'
      ' linkAvatar,'
      ' pathAvatar'
      ') '
      'VALUES(?,?,?,?)',
      [
        data['uuid'],
        data['fullName'],
        data['linkAvatar'],
        data['pathAvatar'],
      ],
    );
  } else {
    logger.d(data);
    logger.d(listUserData);
    int value = await db.rawUpdate(
        'UPDATE user_data '
        'SET'
        ' fullName = ?,'
        ' linkAvatar = ?,'
        ' pathAvatar = ?'
        ' WHERE uuid = ?',
        [
          data['fullName'],
          data['linkAvatar'],
          data['pathAvatar'],
          data['uuid']
        ]);
    logger.d(value);
  }
}

Future<List<Map<String, Object?>>> readUserDataFromSqlite(String uuid) async {
  final db = await kanjiFromApiDatabase;
  return await db.rawQuery(
    'SELECT * FROM user_data '
    'WHERE'
    ' uuid = ?',
    [uuid],
  );
}

class ParametersCompute {
  final Directory path;
  final KanjiFromApi kanjiFromApi;
  final ImageDetailsLink imageMeaningData;
  final String uuid;

  ParametersCompute({
    required this.path,
    required this.kanjiFromApi,
    required this.imageMeaningData,
    required this.uuid,
  });
}

Future<KanjiFromApi?> storeKanjiToSqlite(
  KanjiFromApi kanjiFromApi,
  ImageDetailsLink imageMeaningData,
  String uuid,
) async {
  final dirDocumentPath = await getApplicationDocumentsDirectory();
  final (kanjiFromApiDownloaded, imageMeaningPath) = await compute(
      downloadKanjiDataFromApiComputeVersion,
      ParametersCompute(
        kanjiFromApi: kanjiFromApi,
        path: dirDocumentPath,
        imageMeaningData: imageMeaningData,
        uuid: uuid,
      ));

  final imageMeaningDownloaded = ImageDetailsLink(
    kanji: imageMeaningData.kanji,
    link: imageMeaningPath,
    linkHeight: imageMeaningData.linkHeight,
    linkWidth: imageMeaningData.linkWidth,
  );

  await insertPathsInDB(
    kanjiFromApiDownloaded,
    imageMeaningDownloaded,
    uuid,
  );
  return Future(() => kanjiFromApiDownloaded);
}

Future<(KanjiFromApi, String)> downloadKanjiDataFromApiComputeVersion(
  ParametersCompute parametersCompute,
) async {
  final examplesMap = await downloadExamples(parametersCompute);
  logger.d('downloading examples');
  final strokesPaths = await downloadStrokesData(parametersCompute);
  final imageMeaning = await downloadImageDetails(parametersCompute);

  final kanjiMap = await downloadKanjidata(parametersCompute);

  final List<Example> examples = [];
  for (var exampleMap in examplesMap) {
    final audioExample = AudioExamples(
      opus: exampleMap['opus'] ?? '',
      aac: exampleMap['aac'] ?? '',
      ogg: exampleMap['ogg'] ?? '',
      mp3: exampleMap['mp3'] ?? '',
    );
    final example = Example(
        japanese: exampleMap['japanese'] ?? '',
        meaning: Meaning(english: exampleMap['meaning'] ?? ''),
        audio: audioExample);
    examples.add(example);
  }

  final strokes = Strokes(count: strokesPaths.length, images: strokesPaths);

  final storedKanjiFromApi = KanjiFromApi(
      kanjiCharacter: kanjiMap['kanjiCharacter'] ?? '',
      englishMeaning: kanjiMap['englishMeaning'] ?? '',
      kanjiImageLink: kanjiMap['kanjiImageLink'] ?? '',
      katakanaMeaning: kanjiMap['katakanaMeaning'] ?? '',
      hiraganaMeaning: kanjiMap['hiraganaMeaning'] ?? '',
      videoLink: kanjiMap['videoLink'] ?? '',
      section: int.parse(kanjiMap['section'] ?? '0'),
      statusStorage: StatusStorage.stored,
      accessToKanjiItemsButtons: true,
      example: examples,
      strokes: strokes);

  return (storedKanjiFromApi, imageMeaning);
}

Future<List<Map<String, String>>> downloadExamples(
    ParametersCompute parametersCompute) async {
  List<Map<String, String>> exampleMaps = [];
  for (var example in parametersCompute.kanjiFromApi.example) {
    final exampleMap = await downloadExample(example, parametersCompute);
    exampleMaps.add(exampleMap);
  }

  return exampleMaps;
}

Future<String> downloadImageDetails(
  ParametersCompute parametersCompute,
) async {
  final path = getPathToDocuments(
      dirDocumentPath: parametersCompute.path,
      link: parametersCompute.imageMeaningData.link,
      uuid: parametersCompute.uuid);
  Dio dio = Dio();
  logger.d('download examples ready');
  await dio.download(
    parametersCompute.imageMeaningData.link,
    path,
    onReceiveProgress: (received, total) {},
  );
  return path;
}

Future<Map<String, String>> downloadExample(
  Example example,
  ParametersCompute parametersCompute,
) async {
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];
  final audioLinks = [
    example.audio.opus,
    example.audio.aac,
    example.audio.ogg,
    example.audio.mp3
  ];

  for (var audioLink in audioLinks) {
    final path = getPathToDocuments(
        dirDocumentPath: parametersCompute.path,
        link: audioLink,
        uuid: parametersCompute.uuid);
    pathsToDocuments.add(path);
    Dio dio = Dio();
    logger.d(audioLink);

    addToFutureGroup(path: path, link: audioLink, group: group, dio: dio);
  }

  group.close();

  try {
    await group.future
        .timeout(const Duration(milliseconds: durationTimeOutMili));
  } catch (e) {
    logger.e('error in examples download');
    logger.e(e);
    rethrow;
  }

  return {
    'japanese': example.japanese,
    'meaning': example.meaning.english,
    'opus': pathsToDocuments[0],
    'aac': pathsToDocuments[1],
    'ogg': pathsToDocuments[2],
    'mp3': pathsToDocuments[3],
    'kanjiCharacter': parametersCompute.kanjiFromApi.kanjiCharacter,
  };
}

Future<List<String>> downloadStrokesData(
    ParametersCompute parametersCompute) async {
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];
  for (var strokeImageLink in parametersCompute.kanjiFromApi.strokes.images) {
    final path = getPathToDocuments(
        dirDocumentPath: parametersCompute.path,
        link: strokeImageLink,
        uuid: parametersCompute.uuid);

    pathsToDocuments.add(path);
    Dio dio = Dio();
    addToFutureGroup(path: path, link: strokeImageLink, group: group, dio: dio);
  }

  group.close();

  try {
    await group.future
        .timeout(const Duration(milliseconds: durationTimeOutMili));
  } catch (e) {
    logger.e('error in examples download');
    logger.e(e);
    rethrow;
  }

  return pathsToDocuments;
}

Future<Map<String, String>> downloadKanjidata(
    ParametersCompute parametersCompute) async {
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];

  List<String> listLinks = [
    parametersCompute.kanjiFromApi.kanjiImageLink,
    parametersCompute.kanjiFromApi.videoLink
  ];

  for (var kanjiLink in listLinks) {
    final path = getPathToDocuments(
        dirDocumentPath: parametersCompute.path,
        link: kanjiLink,
        uuid: parametersCompute.uuid);
    Dio dio = Dio();
    pathsToDocuments.add(path);
    addToFutureGroup(path: path, link: kanjiLink, group: group, dio: dio);
  }

  group.close();

  try {
    await group.future
        .timeout(const Duration(milliseconds: durationTimeOutMili));
  } catch (e) {
    logger.e('error in examples download');
    logger.e(e);
    rethrow;
  }

  return {
    'kanjiCharacter': parametersCompute.kanjiFromApi.kanjiCharacter,
    'englishMeaning': parametersCompute.kanjiFromApi.englishMeaning,
    'kanjiImageLink': pathsToDocuments[0],
    'katakanaMeaning': parametersCompute.kanjiFromApi.katakanaMeaning,
    'hiraganaMeaning': parametersCompute.kanjiFromApi.hiraganaMeaning,
    'videoLink': pathsToDocuments[1],
    'section': parametersCompute.kanjiFromApi.section.toString()
  };
}

Future<int> insertPathsInDB(
  KanjiFromApi kanjifromApi,
  ImageDetailsLink imageMeaningDownloaded,
  String uuid,
) async {
  final kanjiMap = {
    'kanjiCharacter': kanjifromApi.kanjiCharacter,
    'englishMeaning': kanjifromApi.englishMeaning,
    'kanjiImageLink': kanjifromApi.kanjiImageLink,
    'katakanaMeaning': kanjifromApi.katakanaMeaning,
    'hiraganaMeaning': kanjifromApi.hiraganaMeaning,
    'videoLink': kanjifromApi.videoLink,
    'section': kanjifromApi.section,
    'uuid': uuid,
  };
  final dbKanjiFromApi = await kanjiFromApiDatabase;
  int id = await dbKanjiFromApi.insert("kanji_FromApi", kanjiMap);

  await dbKanjiFromApi.insert("image_meaning", {
    'kanjiCharacter': kanjifromApi.kanjiCharacter,
    'link': imageMeaningDownloaded.link,
    'linkHeight': imageMeaningDownloaded.linkHeight,
    'linkWidth': imageMeaningDownloaded.linkWidth,
    'uuid': uuid,
    'kanji_id': id,
  });

  FutureGroup<int> groupStrokesDb = FutureGroup<int>();
  final strokes = kanjifromApi.strokes.images.map((e) {
    return {
      'strokeImageLink': e,
      'kanjiCharacter': kanjifromApi.kanjiCharacter,
      'uuid': uuid,
      'kanji_id': id,
    };
  });
  final dbStrokes = await kanjiFromApiDatabase;
  for (var strokesMap in strokes) {
    groupStrokesDb.add(dbStrokes.insert('strokes', strokesMap));
  }

  groupStrokesDb.close();

  await groupStrokesDb.future;

  final exampleMaps = kanjifromApi.example.map((e) {
    Map<String, Object> mapAudios = {};
    mapAudios['opus'] = e.audio.opus;
    mapAudios['aac'] = e.audio.aac;
    mapAudios['ogg'] = e.audio.ogg;
    mapAudios['mp3'] = e.audio.mp3;
    mapAudios['japanese'] = e.japanese;
    mapAudios['meaning'] = e.meaning.english;
    mapAudios['kanjiCharacter'] = kanjifromApi.kanjiCharacter;
    mapAudios['uuid'] = uuid;
    mapAudios['kanji_id'] = id;
    return mapAudios;
  });

  FutureGroup<int> groupExamplesDb = FutureGroup<int>();
  final dbExamples = await kanjiFromApiDatabase;
  for (var exampleMap in exampleMaps) {
    groupExamplesDb.add(dbExamples.insert('examples', exampleMap));
  }

  groupExamplesDb.close();

  await groupExamplesDb.future;

  return id;
}
