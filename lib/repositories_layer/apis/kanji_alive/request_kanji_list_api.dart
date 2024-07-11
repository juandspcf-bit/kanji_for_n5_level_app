import 'dart:convert';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_api.dart';

class KanjiAliveApi {
  static Future<List<KanjiFromApi>> getKanjiList(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacters,
    int section,
    String uuid,
  ) async {
    return await Isolate.run<List<KanjiFromApi>>(() async {
/*       final localHostResult = await RequestsApi.getKanjiDataLocalHost(
        '大',
        uuid,
      );
      logger.d(localHostResult.body); */

      final (
        indexesFromKanjisToRequestToApi,
        indexesFromStoredKanjis,
        listOfKanjisToRequestToApi,
        listOfStoredKanjis,
      ) = getGroupedKanjisAccordingToItsStorageStatus(
        storedKanjis,
        kanjisCharacters,
      );

      //when all the kanjis are stored
      if (kanjisCharacters.length == listOfStoredKanjis.length) {
        final List<KanjiFromApi> kanjisFromApiStored = [];
        for (int i = 0; i < listOfStoredKanjis.length; i++) {
          for (int j = 0; j < storedKanjis.length; j++) {
            if (listOfStoredKanjis[i] == storedKanjis[j].kanjiCharacter) {
              kanjisFromApiStored.add(storedKanjis[j]);
              break;
            }
          }
        }
        return kanjisFromApiStored;
      }

      //when all the kanjis are online
      if (kanjisCharacters.length == listOfKanjisToRequestToApi.length) {
        return await fetchListOfKanjis(
          listOfKanjisToRequestToApi: listOfKanjisToRequestToApi,
          section: section,
        );
      }

      //when there are kanjis which are online and stored
      final kanjisFromApiOnline = await fetchListOfKanjis(
        listOfKanjisToRequestToApi: listOfKanjisToRequestToApi,
        section: section,
      );

      final kanjisFromApiOnlineStored = List<KanjiFromApi>.filled(
          kanjisCharacters.length, kanjisFromApiOnline.first);
      for (int i = 0; i < indexesFromKanjisToRequestToApi.length; i++) {
        kanjisFromApiOnlineStored[indexesFromKanjisToRequestToApi[i]] =
            kanjisFromApiOnline[i];
      }
      for (int i = 0; i < listOfStoredKanjis.length; i++) {
        for (int j = 0; j < storedKanjis.length; j++) {
          if (listOfStoredKanjis[i] == storedKanjis[j].kanjiCharacter) {
            kanjisFromApiOnlineStored[indexesFromStoredKanjis[i]] =
                storedKanjis[j];
            break;
          }
        }
      }

      return kanjisFromApiOnlineStored;
    });
  }

  static Future<List<KanjiFromApi>> fetchListOfKanjis({
    required List<String> listOfKanjisToRequestToApi,
    required int section,
  }) async {
    FutureGroup<Response> group = FutureGroup<Response>();

    for (final kanji in listOfKanjisToRequestToApi) {
      group.add(RequestsApi.getKanjiData(kanji));
    }

    group.close();

    final kanjiInformationList = await group.future.timeout(
      const Duration(seconds: 25),
    );

    List<Map<String, dynamic>> bodies = [];
    List<KanjiFromApi> kanjisFromApi = [];

    for (final kanjiInformation in kanjiInformationList) {
      bodies.add(json.decode(kanjiInformation.body));
    }

    for (final body in bodies) {
      kanjisFromApi.add(buildKanjiInfoFromApi(body, section));
    }

    return kanjisFromApi;
  }

  static (List<int>, List<int>, List<String>, List<String>)
      getGroupedKanjisAccordingToItsStorageStatus(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacters,
  ) {
    final copyKanjis = [...kanjisCharacters];
    List<int> indexesFromStoredKanjis = [];
    List<int> indexesFromKanjisToRequestToApi = [];
    for (int i = 0; i < kanjisCharacters.length; i++) {
      bool toKeep = true;
      for (int j = 0; j < storedKanjis.length; j++) {
        if (kanjisCharacters[i] == storedKanjis[j].kanjiCharacter) {
          indexesFromStoredKanjis.add(i);
          toKeep = false;
          continue;
        }
      }
      if (toKeep) {
        indexesFromKanjisToRequestToApi.add(i);
      }
    }
    List<String> listOfKanjisToRequestToApi = [];
    for (var index in indexesFromKanjisToRequestToApi) {
      listOfKanjisToRequestToApi.add(copyKanjis[index]);
    }

    List<String> listOfStoredKanjis = [];
    for (var index in indexesFromStoredKanjis) {
      listOfStoredKanjis.add(copyKanjis[index]);
    }

    return (
      indexesFromKanjisToRequestToApi,
      indexesFromStoredKanjis,
      listOfKanjisToRequestToApi,
      listOfStoredKanjis,
    );
  }

  static Future<KanjiFromApi> getKanjiFromEnglishWord(
      String word, String uuid) async {
    try {
      Response value = await RequestsApi.getKanjiFromEnglishWord(word);

      final body = json.decode(value.body);
      logger.d(body);
      List<dynamic> data = body;

      Map<String, dynamic> map = data.first;
      Map<String, dynamic> kanjiMap = map['kanji'];

      logger.d(kanjiMap['character']);
      final kanjiList = await KanjiAliveApi.getKanjiList(
          [], [kanjiMap['character']], 0, uuid);

      return kanjiList.first;
    } catch (e) {
      throw KanjiFetchingException("error getting kanji data for $word");
    }
  }

  static Future<List<String>> getKanjisByGrade(int grade) async {
    try {
      Response value = await RequestsApi.getKanjisByGrade(grade);
      logger.d(value);
      final body = json.decode(value.body);
      logger.d(body);
      List<dynamic> data = body;

      final List<String> kanjiCharacters = [];
      for (final dataEntry in data) {
        final kanjiEntry = dataEntry as Map<String, dynamic>;
        kanjiCharacters.add(kanjiEntry["kanji"]["character"]);
      }

      return kanjiCharacters;
    } catch (e) {
      logger.e(e);
      throw KanjiFetchingException("error getting kanjis by $grade");
    }
  }
}
