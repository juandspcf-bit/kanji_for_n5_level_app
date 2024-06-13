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
      uuid,
    );
  }

  @override
  Future<KanjiFromApi> requestSingleKanjiToApi(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    final kanjiList = await KanjiAliveApi.getKanjiList(
      [],
      [kanjiCharacter],
      section,
      uuid,
    );
    return kanjiList[0];
  }

  @override
  Future<void> getKanjiFromEnglishWord(
      String word,
      void Function(List<KanjiFromApi>) onSuccess,
      void Function() onError,
      String uuid) async {
    KanjiAliveApi.getKanjiFromEnglishWord(
      word,
      onSuccess,
      onError,
      uuid,
    );
  }

  @override
  Future<void> getTranslatedKanjiFromEnglishWord(
    String word,
    String sourceLanguage,
    String targetLanguage,
    String uuid,
    void Function(KanjiFromApi kanjiFromApi) onSuccess,
  ) async {
    KanjiAliveApi.getKanjiFromEnglishWord(
      word,
      (kanjiList) async {
        final translatedMeaning = await translationApiService.translateText(
          kanjiList[0].englishMeaning,
          sourceLanguage,
          targetLanguage,
        );
        var words = "";

        final length = kanjiList[0].example.length;
        for (var i = 0; i < length; i++) {
          final exam = kanjiList[0].example[i];
          if (i == length - 1) {
            words += exam.meaning.english;
            continue;
          }
          words += "${exam.meaning.english};";
        }

        final translatedExamplesChain =
            await translationApiService.translateText(
          words,
          "en",
          "es",
        );

        final translatedExamplesList =
            translatedExamplesChain.translatedText.split(";");

        final List<Example> newListExamples = [];

        for (int i = 0; i < translatedExamplesList.length; i++) {
          newListExamples.add(Example(
              japanese: kanjiList[0].example[i].japanese,
              meaning: Meaning(english: translatedExamplesList[i]),
              audio: kanjiList[0].example[i].audio));
        }

        final newKanji = kanjiList[0].copyWith(
          englishMeaning: translatedMeaning.translatedText,
          example: newListExamples,
        );

        onSuccess(newKanji);
      },
      () {},
      uuid,
    );
  }
}
