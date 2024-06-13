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

      FutureGroup<Response> group = FutureGroup<Response>();
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
        final List<KanjiFromApi> fixedLengthList = [];
        for (int i = 0; i < listOfStoredKanjis.length; i++) {
          for (int j = 0; j < storedKanjis.length; j++) {
            if (listOfStoredKanjis[i] == storedKanjis[j].kanjiCharacter) {
              fixedLengthList.add(storedKanjis[j]);
              break;
            }
          }
        }
        return fixedLengthList;
      }

      for (final kanji in listOfKanjisToRequestToApi) {
        group.add(RequestsApi.getKanjiData(kanji));
      }

      group.close();

      List<Map<String, dynamic>> bodies = [];
      List<KanjiFromApi> kanjisFromApi = [];

      //when all the kanjis are online
      if (kanjisCharacters.length == listOfKanjisToRequestToApi.length) {
        //fetch all the kanjis with a http request
        List<Response> kanjiInformationList = await group.future.timeout(
          const Duration(
            seconds: 25,
          ),
        );

        //processing the responses
        for (final kanjiInformation in kanjiInformationList) {
          bodies.add(json.decode(kanjiInformation.body));
        }

        for (final body in bodies) {
          kanjisFromApi.add(buildKanjiInfoFromApi(body, section));
        }
        return kanjisFromApi;
      }

      List<Response> kanjiInformationList = await group.future.timeout(
        const Duration(seconds: 25),
      );
      for (final kanjiInformation in kanjiInformationList) {
        bodies.add(json.decode(kanjiInformation.body));
      }

      for (final body in bodies) {
        kanjisFromApi.add(buildKanjiInfoFromApi(body, section));
      }
      final fixedLengthList = List<KanjiFromApi>.filled(
          kanjisCharacters.length, kanjisFromApi.first);
      for (int i = 0; i < indexesFromKanjisToRequestToApi.length; i++) {
        fixedLengthList[indexesFromKanjisToRequestToApi[i]] = kanjisFromApi[i];
      }
      for (int i = 0; i < listOfStoredKanjis.length; i++) {
        for (int j = 0; j < storedKanjis.length; j++) {
          if (listOfStoredKanjis[i] == storedKanjis[j].kanjiCharacter) {
            fixedLengthList[indexesFromStoredKanjis[i]] = storedKanjis[j];
            break;
          }
        }
      }

      return fixedLengthList;
    });
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
}
