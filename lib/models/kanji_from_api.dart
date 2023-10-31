class KanjiFromApi {
  final String kanjiCharacter;
  final String englishMeaning;
  final String kanjiImageLink;
  final String katakanaMeaning;
  final String hiraganaMeaning;
  final String videoLink;
  final List<Example> example;
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

  @override
  String toString() {
    return 'kanji character $kanjiCharacter, : meaning: $englishMeaning, image link: $kanjiImageLink';
  }
}

class Example {
  final String japanese;
  final Meaning meaning;
  final AudioExamples audio;

  Example({
    required this.japanese,
    required this.meaning,
    required this.audio,
  });
}

class Meaning {
  final String english;
  Meaning({required this.english});
}

class AudioExamples {
  final String opus;
  final String aac;
  final String ogg;
  final String mp3;

  AudioExamples(
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

KanjiFromApi builKanjiInfoFromApi(Map<String, dynamic> body) {
  final Map<String, dynamic> kanjiInfo = body['kanji'];

  final String kanjiCharacterFromAPI = kanjiInfo['character'];

  final Map<String, dynamic> kanjiStrokes = kanjiInfo["strokes"];

  final List<dynamic> kanjiImagesFromApis = kanjiStrokes["images"];
  final kanjiImages = kanjiImagesFromApis.map((e) => e as String).toList();

  final String kanjiImageFromAPI = kanjiImages.last;
  final strokesInfo = Strokes(
    count: kanjiStrokes['count'],
    images: kanjiImages,
  );

  final Map<String, dynamic> kanjiMeaning = kanjiInfo["meaning"];
  final String englishMeaningFromAPI = kanjiMeaning['english'];

  final Map<String, dynamic> kanjiOnyomi = kanjiInfo["onyomi"];
  final String katakanaMeaningFromAPI = kanjiOnyomi['katakana'];

  final Map<String, dynamic> kanjiKunyomi = kanjiInfo['kunyomi'];
  final String hiraganaMeaningFromAPI = kanjiKunyomi['hiragana'];

  final Map<String, dynamic> kanjiVideo = kanjiInfo['video'];
  final String videoLinkFromAPI = kanjiVideo['mp4'];

  final List<dynamic> examplesFromAPI = body['examples'];

  List<Example> examples = examplesFromAPI.map((e) {
    //
    final String japanese = e["japanese"];
    final Map<String, dynamic> meaningMap = e['meaning'];
    final meaning = Meaning(english: meaningMap['english'] as String);
    final Map<String, dynamic> audioMap = e['audio'];
    final audio = AudioExamples(
        opus: audioMap['opus'],
        aac: audioMap['aac'],
        ogg: audioMap['ogg'],
        mp3: audioMap['mp3']);

    return Example(
      japanese: japanese,
      meaning: meaning,
      audio: audio,
    );
  }).toList();

  final kanjiFromApi = KanjiFromApi(
      kanjiCharacter: kanjiCharacterFromAPI,
      englishMeaning: englishMeaningFromAPI,
      kanjiImageLink: kanjiImageFromAPI,
      katakanaMeaning: katakanaMeaningFromAPI,
      hiraganaMeaning: hiraganaMeaningFromAPI,
      videoLink: videoLinkFromAPI,
      example: examples,
      strokes: strokesInfo);

  return kanjiFromApi;
}
