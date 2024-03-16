import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:path_provider/path_provider.dart';

class ParametersCompute {
  final Directory path;
  final KanjiFromApi kanjiFromApi;
  final String uuid;

  ParametersCompute({
    required this.path,
    required this.kanjiFromApi,
    required this.uuid,
  });
}

Future<KanjiFromApi?> storeKanjiToSqlDB(
  KanjiFromApi kanjiFromApi,
  String uuid,
) async {
  final dirDocumentPath = await getApplicationDocumentsDirectory();
  final kanjiFromApiDownloaded = await compute(
      downloadKanjiDataFromApiComputeVersion,
      ParametersCompute(
        kanjiFromApi: kanjiFromApi,
        path: dirDocumentPath,
        uuid: uuid,
      ));

  await insertPathsInDB(kanjiFromApiDownloaded, uuid);
  return Future(() => kanjiFromApiDownloaded);
}

Future<KanjiFromApi> downloadKanjiDataFromApiComputeVersion(
    ParametersCompute parametersCompute) async {
  final examplesMap = await downloadExampleData(parametersCompute);
  final strokesPaths = await downloadStrokesData(parametersCompute);

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

  return KanjiFromApi(
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
}

Future<List<Map<String, String>>> downloadExampleData(
    ParametersCompute parametersCompute) async {
  List<Map<String, String>> exampleMaps = [];
  for (var example in parametersCompute.kanjiFromApi.example) {
    final exampleMap =
        await downloadExampleComputeVersion(example, parametersCompute);
    exampleMaps.add(exampleMap);
  }

  return exampleMaps;
}

Future<Map<String, String>> downloadExampleComputeVersion(
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
    addToFutureGroup(path: path, link: audioLink, group: group, dio: dio);
  }

  group.close();

  try {
    await group.future;
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
    await group.future;
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
    await group.future;
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

Future<int> insertPathsInDB(KanjiFromApi kanjifromApi, String uuid) async {
  final exampleMaps = kanjifromApi.example.map((e) {
    Map<String, String> mapAudios = {};
    mapAudios['opus'] = e.audio.opus;
    mapAudios['aac'] = e.audio.aac;
    mapAudios['ogg'] = e.audio.ogg;
    mapAudios['mp3'] = e.audio.mp3;
    mapAudios['japanese'] = e.japanese;
    mapAudios['meaning'] = e.meaning.english;
    mapAudios['kanjiCharacter'] = kanjifromApi.kanjiCharacter;
    mapAudios['uuid'] = uuid;
    return mapAudios;
  });

  FutureGroup<int> groupExamplesDb = FutureGroup<int>();
  final dbExamples = await kanjiFromApiDatabase;
  for (var exampleMap in exampleMaps) {
    groupExamplesDb.add(dbExamples.insert('examples', exampleMap));
  }

  groupExamplesDb.close();

  await groupExamplesDb.future;

  FutureGroup<int> groupStrokesDb = FutureGroup<int>();
  final strokes = kanjifromApi.strokes.images.map((e) {
    return {
      'strokeImageLink': e,
      'kanjiCharacter': kanjifromApi.kanjiCharacter,
      'uuid': uuid,
    };
  });
  final dbStrokes = await kanjiFromApiDatabase;
  for (var strokesMap in strokes) {
    groupStrokesDb.add(dbStrokes.insert('strokes', strokesMap));
  }

  groupStrokesDb.close();

  await groupStrokesDb.future;

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
  return await dbKanjiFromApi.insert("kanji_FromApi", kanjiMap);
}
