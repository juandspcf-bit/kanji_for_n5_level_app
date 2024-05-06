import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDownload extends Notifier<ErrorDownloadKanji> {
  @override
  ErrorDownloadKanji build() {
    return ErrorDownloadKanji(kanjiCharacter: '');
  }

  void setKanjiError(String kanjiCharacter) {
    state = ErrorDownloadKanji(kanjiCharacter: kanjiCharacter);
  }
}

final errorDownloadProvider =
    NotifierProvider<ErrorDownload, ErrorDownloadKanji>(ErrorDownload.new);

class ErrorDownloadKanji {
  final String kanjiCharacter;

  ErrorDownloadKanji({
    required this.kanjiCharacter,
  });
}
