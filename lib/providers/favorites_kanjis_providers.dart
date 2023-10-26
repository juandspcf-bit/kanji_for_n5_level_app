import 'package:async/async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesKanjis extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }

  void setInitialState(List<(String, String, String)> myFavoritesCached) {
    var listKanjiCharacter = myFavoritesCached;
    listKanjiCharacter.map((e) => e.$3).toList();
    //state = initial;
  }

  void getKanjis(List<String> kanjis) {
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

      state = kanjisFromApi;
    }).catchError((onError) {});
  }

  Future<Response> getKanjiData(String kanji) async {
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

final favoritesKanjisProvider =
    NotifierProvider<FavoritesKanjis, List<KanjiFromApi>>(FavoritesKanjis.new);

List<(String, String, String)> myFavoritesCached = [];
