import 'package:dio/dio.dart';
import 'package:kanji_for_n5_level_app/API_Files/key_file_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kanji_for_n5_level_app/main.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> getKanjiData(String kanji) async {
  final url = Uri.https(
    "kanjialive-api.p.rapidapi.com",
    "api/public/kanji/$kanji",
  );

  final kanjiInformation = await http.get(
    url,
    headers: {
      'X-RapidAPI-Key': xRapidAPIKey,
      'X-RapidAPI-Host': 'kanjialive-api.p.rapidapi.com'
    },
  );

  return json.decode(kanjiInformation.body);
}

Future<(String, String)> downloadAndCacheAvatar(String uuid) async {
  final avatarLink = await storageService.getDownloadLink(uuid);

  final dio = Dio();
  final pathBase = (await getApplicationDocumentsDirectory()).path;
  final pathAvatar = '$pathBase/$uuid.jpg';

  await dio.download(
    avatarLink,
    pathAvatar,
  );

  return (avatarLink, pathAvatar);
}
