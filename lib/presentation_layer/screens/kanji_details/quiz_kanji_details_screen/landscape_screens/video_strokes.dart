import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/meaning_definition.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_video_strokes.dart';

class VideoStrolesLandScape extends ConsumerWidget {
  const VideoStrolesLandScape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiFromApi = ref.watch(kanjiDetailsProvider)!.kanjiFromApi;
    return connectivityData == ConnectionStatus.noConnected &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionDetailsScreen()
        : SafeArea(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const Expanded(child: VideoWrapper()),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MeaningAndDefinition(
                        englishMeaning: kanjiFromApi.englishMeaning,
                        hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
                        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
                        katakanaRomaji: kanjiFromApi.katakanaRomaji,
                        katakanaMeaning: kanjiFromApi.katakanaMeaning,
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
