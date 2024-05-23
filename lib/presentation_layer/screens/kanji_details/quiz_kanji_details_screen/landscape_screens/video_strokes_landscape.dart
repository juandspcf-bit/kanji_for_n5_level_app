import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/video_widget/video_wrapper.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/meaning_definition.dart';

class VideoStrokesLandScape extends ConsumerWidget {
  const VideoStrokesLandScape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.watch(kanjiDetailsProvider)!.kanjiFromApi;
    return SafeArea(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Expanded(child: VideoWrapper()),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                MeaningAndDefinition(
                  englishMeaning: kanjiFromApi.englishMeaning,
                  hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
                  hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
                  katakanaRomaji: kanjiFromApi.katakanaRomaji,
                  katakanaMeaning: kanjiFromApi.katakanaMeaning,
                ),
                const SizedBox(
                  height: 10,
                ),
                const ImageMeaningKanji(),
              ],
            ),
          ),
        )
      ]),
    );
  }
}