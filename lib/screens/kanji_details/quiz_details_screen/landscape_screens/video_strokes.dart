import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_screens.dart/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tabs/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tabs/meaning_definition.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/tabs/tab_video_strokes.dart';

class VideoStrolesLandScape extends ConsumerWidget {
  const VideoStrolesLandScape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiFromApi = ref.watch(kanjiDetailsProvider)!.kanjiFromApi;
    return connectivityData == ConnectivityResult.none &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionScreen(
            message:
                'No internet connection, you will be able to acces the info when the connection is restored',
          )
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
                        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
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
