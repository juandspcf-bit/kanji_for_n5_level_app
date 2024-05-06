import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDelete extends Notifier<ErrorDeleteKanji> {
  @override
  ErrorDeleteKanji build() {
    return ErrorDeleteKanji(kanjiCharacter: '');
  }

  void setKanjiError(String kanjiCharacter) {
    state = ErrorDeleteKanji(kanjiCharacter: kanjiCharacter);
  }
}

final errorDeleteProvider =
    NotifierProvider<ErrorDelete, ErrorDeleteKanji>(ErrorDelete.new);

class ErrorDeleteKanji {
  final String kanjiCharacter;

  ErrorDeleteKanji({
    required this.kanjiCharacter,
  });
}
