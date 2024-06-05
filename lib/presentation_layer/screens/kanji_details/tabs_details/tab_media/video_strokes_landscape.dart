import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_wrapper.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/meaning_definition.dart';

class VideoStrokesPortrait extends ConsumerWidget {
  const VideoStrokesPortrait({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.watch(kanjiDetailsProvider)!.kanjiFromApi;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const VideoWrapper(),
          const SizedBox(
            height: 20,
          ),
          MeaningAndDefinition(
            englishMeaning: kanjiFromApi.englishMeaning,
            hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
            hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
            katakanaRomaji: kanjiFromApi.katakanaRomaji,
            katakanaMeaning: kanjiFromApi.katakanaMeaning,
          ),
          const SizedBox(
            height: 20,
          ),
          const ImageMeaningKanji(),
        ],
      ),
    );
  }
}
