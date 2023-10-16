class KanjiFromApi {
  final String kanjiCharacter;
  final String englishMeaning;
  final String kanjiImageLink;
  final String katakanaMeaning;
  final String hiraganaMeaning;
  final String videoLink;
  final List<Examples> example;
  final Strokes strokes;

  KanjiFromApi(
      {required this.kanjiCharacter,
      required this.englishMeaning,
      required this.kanjiImageLink,
      required this.katakanaMeaning,
      required this.hiraganaMeaning,
      required this.videoLink,
      required this.example,
      required this.strokes});
}

class Examples {
  final String japanese;
  final Meaning meaning;
  final Audio audio;

  Examples({
    required this.japanese,
    required this.meaning,
    required this.audio,
  });
}

class Meaning {
  final String meaning;
  Meaning({required this.meaning});
}

class Audio {
  final String opus;
  final String aac;
  final String ogg;
  final String mp3;

  Audio(
      {required this.opus,
      required this.aac,
      required this.ogg,
      required this.mp3});
}

class Strokes {
  final int count;
  final List<String> images;

  Strokes({
    required this.count,
    required this.images,
  });
}
