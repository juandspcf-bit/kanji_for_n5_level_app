import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:http/http.dart' as http;

class RequestApi {
  static void getKanjis(
    List<KanjiFromApi> storedKanjisFromApi,
    List<String> kanjisCharacteres,
    void Function(List<KanjiFromApi> kanjisFromApi) onSuccesRequest,
    void Function() onErrorRequest,
  ) {
    FutureGroup<Response> group = FutureGroup<Response>();

    final lists = getIndexedKanjis(
      storedKanjisFromApi,
      kanjisCharacteres,
    );

    if (kanjisCharacteres.length == lists.$4.length) {
      final List<KanjiFromApi> fixedLengthList = [];
      for (int i = 0; i < lists.$4.length; i++) {
        for (int j = 0; j < storedKanjisFromApi.length; j++) {
          if (lists.$4[i] == storedKanjisFromApi[j].kanjiCharacter) {
            fixedLengthList.add(storedKanjisFromApi[j]);
            break;
          }
        }
      }
      onSuccesRequest(fixedLengthList);
      return;
    }

    for (final kanji in lists.$3) {
      group.add(getKanjiData(kanji));
    }

    group.close();

    List<Map<String, dynamic>> bodies = [];
    List<KanjiFromApi> kanjisFromApi = [];
    group.future.then((List<Response> kanjiInformationList) {
      for (final kanjiInformation in kanjiInformationList) {
        bodies.add(json.decode(kanjiInformation.body));
      }

      for (final body in bodies) {
        kanjisFromApi.add(builKanjiInfoFromApi(body));
      }
      final fixedLengthList = List<KanjiFromApi>.filled(
          kanjisCharacteres.length, kanjisFromApi.first);
      for (int i = 0; i < lists.$1.length; i++) {
        fixedLengthList[lists.$1[i]] = kanjisFromApi[i];
      }
      for (int i = 0; i < lists.$4.length; i++) {
        for (int j = 0; j < storedKanjisFromApi.length; j++) {
          if (lists.$4[i] == storedKanjisFromApi[j].kanjiCharacter) {
            fixedLengthList[lists.$2[i]] = storedKanjisFromApi[j];
            break;
          }
        }
        /* print(
            'testing ${storedKanjisFromApi[i].kanjiCharacter} , ${kanjisCharacteres[lists.$2[i]]}'); */
      }

      onSuccesRequest(fixedLengthList);
    }).catchError((onError) {
      onErrorRequest();
    });
  }

  static Future<Response> getKanjiData(String kanji) async {
    final url = Uri.https(
      "kanjialive-api.p.rapidapi.com",
      "api/public/kanji/$kanji",
    );

    return http.get(
      url,
      headers: {
        'X-RapidAPI-Key': xRapidAPIKey,
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com'
      },
    );
  }

  static (List<int>, List<int>, List<String>, List<String>) getIndexedKanjis(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjis,
  ) {
    final copyKanjis = [...kanjis];
    List<int> indexesToRemove = [];
    List<int> indexesToKeep = [];
    for (int i = 0; i < kanjis.length; i++) {
      bool toKeep = true;
      for (int j = 0; j < storedKanjis.length; j++) {
        if (kanjis[i] == storedKanjis[j].kanjiCharacter) {
          indexesToRemove.add(i);
          toKeep = false;
          continue;
        }
      }
      if (toKeep) {
        indexesToKeep.add(i);
      }
    }
    List<String> listToKeep = [];
    for (var index in indexesToKeep) {
      listToKeep.add(copyKanjis[index]);
    }

    List<String> listToRemove = [];
    for (var index in indexesToRemove) {
      listToRemove.add(copyKanjis[index]);
    }

    return (indexesToKeep, indexesToRemove, listToKeep, listToRemove);
  }
}
