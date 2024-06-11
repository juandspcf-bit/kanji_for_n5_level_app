abstract class TranslationApiService {
  Future<void> translateText(
    String text,
    String sourceLanguage,
    String targetLanguage,
  );
}
