import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_wrapper.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/image_meaning/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/meaning_definition.dart';

class VideoStrokesPortrait extends ConsumerWidget {
  const VideoStrokesPortrait({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          VideoWrapper(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: MeaningAndDefinition(),
          ),
          SizedBox(
            height: 20,
          ),
          ImageMeaningKanji(),
        ],
      ),
    );
  }
}
