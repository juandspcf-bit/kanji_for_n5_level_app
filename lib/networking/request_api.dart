import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:http/http.dart' as http;

class RequestApi {
  static void getKanjis(
    List<String> kanjis,
    void Function(List<KanjiFromApi> kanjisFromApi) onSuccesRequest,
    void Function() onErrorRequest,
  ) {
    FutureGroup<Response> group = FutureGroup<Response>();

    for (final kanji in kanjis) {
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

      onSuccesRequest(kanjisFromApi);
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
}
