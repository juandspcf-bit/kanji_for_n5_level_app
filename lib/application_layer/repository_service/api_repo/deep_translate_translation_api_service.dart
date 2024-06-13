import 'dart:convert';

import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/translation_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/translated_text.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_api.dart';

class DeepTranslateTranslationApiService extends TranslationApiService {
  @override
  Future<TranslatedText> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    return DeepTranslateService.translateText(
      text,
      sourceLanguage,
      targetLanguage,
    );
  }
}

class DeepTranslateService {
  static Future<TranslatedText> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  ) async {
    try {
      final response = await RequestsApi.translateText(
        text,
        sourceLanguage,
        targetLanguage,
      ).timeout(const Duration(
        seconds: 25,
      ));

      final map = json.decode(response.body) as Map<String, dynamic>;

      logger.d(map);

      return TranslatedText.fromMap(map);
    } catch (e) {
      throw TranslationException("error in translation  for $text");
    }
  }
}
