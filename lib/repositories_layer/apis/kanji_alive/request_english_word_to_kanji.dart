import 'dart:convert';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_kanji_list_api.dart';

class RequestEnglishWordToKanji {
  static void getKanjiFromEnglishWord(
      String word,
      void Function(List<KanjiFromApi>) onSuccess,
      void Function() onError,
      String uuid) async {
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

      onSuccess(kanjiList);
    } catch (e) {
      onError();
    }
  }
}
