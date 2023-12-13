import 'dart:convert';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_kanji_list_api.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class RequestEnglishWordToKanji {
  static void getKanjiFromEnglishWord(String word,
      void Function(List<KanjiFromApi>) onSuccess, void Function() onError) {
    RequestsApi.getKanjiFromEnglishWord(word).then((value) {
      final body = json.decode(value.body);
      logger.d(body);
      List<dynamic> data = body;

      Map<String, dynamic> map = data.first;
      Map<String, dynamic> kanjiMap = map['kanji'];

      logger.d(kanjiMap['character']);
      KanjiAliveApi.getKanjiList(
          [], [kanjiMap['character']], 0, onSuccess, onError);
    }).onError((error, stackTrace) {
      onError();
    });
  }
}
