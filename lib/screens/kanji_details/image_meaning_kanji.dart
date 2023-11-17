import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/kanji_details_provider.dart';

class ImageMeaningKanji extends ConsumerStatefulWidget {
  const ImageMeaningKanji({super.key});

  @override
  ConsumerState<ImageMeaningKanji> createState() => _ImageMeaningKanjiState();
}

class _ImageMeaningKanjiState extends ConsumerState<ImageMeaningKanji> {
  @override
  void initState() {
    super.initState();
    final kanjiData = ref.read(kanjiDetailsProvider);
    final imagesLinks = dbFirebase.collection("sectionPictures");
    imagesLinks
        .where("kanji", isEqualTo: kanjiData!.kanjiFromApi.kanjiCharacter)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {}
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext ctx) {});
  }
}
