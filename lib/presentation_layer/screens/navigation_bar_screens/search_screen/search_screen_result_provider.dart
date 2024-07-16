import 'dart:async';
import 'dart:io';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "search_screen_result_provider.g.dart";

@riverpod
class SearchScreenResult extends _$SearchScreenResult {
  @override
  FutureOr<KanjiFromApi?> build({required String word}) async {
    return await setWord(word);
  }

  FutureOr<KanjiFromApi?> setWord(String word) {
    final trimWord = word.trim();
    return _getKanjiFromEnglishWord(trimWord);
  }

  FutureOr<KanjiFromApi?> _getKanjiFromEnglishWord(String word) async {
    try {
      final defaultLocale = Platform.localeName;
      if (defaultLocale.contains("es_")) {
        final kanjiTranslated = await ref
            .read(kanjiApiServiceProvider)
            .getTranslatedKanjiFromSpanishWord(
              word,
              ref.read(authServiceProvider).userUuid ?? '',
            )
            .timeout(const Duration(seconds: 50));

        return kanjiTranslated;
      }

      final kanjiFromApi = await ref
          .read(kanjiApiServiceProvider)
          .getKanjiFromEnglishWord(
            word,
            ref.read(authServiceProvider).userUuid ?? '',
          )
          .timeout(const Duration(seconds: 50));

      return kanjiFromApi;
    } catch (e) {
      logger.e(e);
      return Future.value(null);
    }
  }
}
