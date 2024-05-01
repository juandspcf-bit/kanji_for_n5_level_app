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
}
