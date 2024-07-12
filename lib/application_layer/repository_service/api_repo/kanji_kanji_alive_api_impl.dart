import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/translation_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_kanji_list_api.dart';

class KanjiAliveApiService implements KanjiApiService {
  KanjiAliveApiService({required this.translationApiService});

  final TranslationApiService translationApiService;

  @override
  Future<List<KanjiFromApi>> requestKanjiListToApi(
      List<KanjiFromApi> storedKanjis,
      List<String> kanjisCharacters,
      int section,
      String uuid) async {
    return KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacters,
      section,
    );
  }

  @override
  Future<KanjiFromApi> requestSingleKanjiToApi(
    String kanjiCharacter,
    int section,
  ) async {
    final kanjiList = await KanjiAliveApi.getKanjiList(
      [],
      [kanjiCharacter],
      section,
    );
    return kanjiList[0];
  }

  @override
  Future<KanjiFromApi> getKanjiFromEnglishWord(String word, String uuid) async {
    return KanjiAliveApi.getKanjiFromEnglishWord(
      word,
      uuid,
    );
  }

  @override
  Future<List<String>> getKanjisByGrade(int grade) {
    return KanjiAliveApi.getKanjisByGrade(grade);
  }

  @override
  Future<KanjiFromApi> getTranslatedKanjiFromSpanishWord(
    String word,
    String uuid,
  ) async {
    final translatedQuery = await translationApiService.translateText(
      word,
      "es",
      "en",
    );

    final kanjiList = await KanjiAliveApi.getKanjiFromEnglishWord(
      translatedQuery.translatedText,
      uuid,
    );

    final translatedMeaning = await translationApiService.translateText(
      kanjiList.englishMeaning,
      "en",
      "es",
    );
    var words = "";

    final length = kanjiList.example.length;
    for (var i = 0; i < length; i++) {
      final exam = kanjiList.example[i];
      if (i == length - 1) {
        words += exam.meaning.english;
        continue;
      }
      words += "${exam.meaning.english};";
    }

    final translatedExamplesChain = await translationApiService.translateText(
      words,
      "en",
      "es",
    );

    final translatedExamplesList =
        translatedExamplesChain.translatedText.split(";");

    final List<Example> newListExamples = [];

    for (int i = 0; i < translatedExamplesList.length; i++) {
      newListExamples.add(Example(
          japanese: kanjiList.example[i].japanese,
          meaning: Meaning(english: translatedExamplesList[i]),
          audio: kanjiList.example[i].audio));
    }

    final newKanji = kanjiList.copyWith(
      englishMeaning: translatedMeaning.translatedText,
      example: newListExamples,
    );

    return newKanji;
  }
}
