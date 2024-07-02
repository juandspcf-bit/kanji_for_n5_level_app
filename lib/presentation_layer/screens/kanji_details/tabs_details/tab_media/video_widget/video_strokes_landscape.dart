import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_wrapper.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/meaning_definition.dart';

class VideoStrokesLandScape extends ConsumerWidget {
  const VideoStrokesLandScape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(child: VideoWrapper()),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                MeaningAndDefinition(),
                SizedBox(height: 10),
                ImageMeaningKanji(),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
