import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';

class RequestsApi {
  static Future<Response> getKanjiData(
    String kanji,
  ) async {
    final url = Uri.https(
      "kanjialive-api.p.rapidapi.com",
      "api/public/kanji/$kanji",
    );

    return http.get(
      url,
      headers: {
        'X-RapidAPI-Key': xRapidAPIKey,
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com',
      },
    );
  }

  static Future<Response> getKanjiFromEnglishWord(String word) async {
    final url = Uri.https("kanjialive-api.p.rapidapi.com",
        "api/public/search/advanced", {'kem': word});

    return http.get(
      url,
      headers: {
        'X-RapidAPI-Key': xRapidAPIKey,
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com'
      },
    );
  }

  static Future<Response> getKanjiDataLocalHost(
    String kanji,
    String uuid,
  ) async {
    final url = Uri.http(
      "172.20.10.2:90",
      "api/v1/kanjis/$kanji",
    );

    return http.get(
      url,
      headers: {
        'X-RapidAPI-Key': xRapidAPIKey,
        'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com',
        'uuid': uuid,
      },
    );
  }

  static Future<Response> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) {
    final url = Uri.https(
      'deep-translate1.p.rapidapi.com',
      "language/translate/v2",
    );

    return http.post(
      url,
      headers: {
        'x-rapidapi-key': xRapidAPIKey,
        'x-rapidapi-host': 'deep-translate1.p.rapidapi.com',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          {"q": text, "source": sourceLanguage, "target": targetLanguage}),
    );
  }
}
