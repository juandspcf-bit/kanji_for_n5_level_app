import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_inserting_data.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_utils.dart';
import 'package:path_provider/path_provider.dart';

Future<KanjiFromApi?> storeKanjiToSqlDBv2(
  KanjiFromApi kanjiFromApi,
  String uuid,
) async {
  if (uuid == '') {
    return null;
  }

  final dirDocumentPath = await getApplicationDocumentsDirectory();
  final kanjiFromApiDownloaded = await compute(
    downloadKanjiDataFromApiComputeVersionv2,
    ParametersCompute(
      kanjiFromApi: kanjiFromApi,
      path: dirDocumentPath,
      uuid: uuid,
    ),
  );

  await insertPathsInDB(kanjiFromApiDownloaded, uuid);
  return Future(() => kanjiFromApiDownloaded);
}

Future<KanjiFromApi> downloadKanjiDataFromApiComputeVersionv2(
    ParametersCompute parametersCompute) async {
  final examplesMap = await downloadExampleDatav2(parametersCompute);
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

Future<List<Map<String, String>>> downloadExampleDatav2(
    ParametersCompute parametersCompute) async {
  List<Map<String, String>> exampleMaps = [];
  for (var example in parametersCompute.kanjiFromApi.example) {
    final exampleMap =
        await downloadExampleComputeVersionv2(example, parametersCompute);
    exampleMaps.add(exampleMap);
  }

  return exampleMaps;
}

Future<Map<String, String>> downloadExampleComputeVersionv2(
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
    addToFutureGroupv2(path: path, link: audioLink, group: group, dio: dio);
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

void addToFutureGroupv2({
  required String path,
  required String link,
  required FutureGroup<Response<dynamic>> group,
  required Dio dio,
}) {
  group.add(dio.download(
    link,
    path,
    onReceiveProgress: (received, total) {
/*         if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
          //you can build progressbar feature too
        } */
    },
  ));
}
