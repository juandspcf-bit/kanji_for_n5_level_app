import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:video_player/video_player.dart';

class KanjiItemAnimated extends ConsumerWidget {
  const KanjiItemAnimated({
    super.key,
    required this.statusStorage,
    required this.kanjiFromApi,
    required this.closedChild,
  });

  final StatusStorage statusStorage;
  final KanjiFromApi kanjiFromApi;
  final Widget closedChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 900),
      openBuilder: (context, closedContainer) {
        return KanjiDetails(
            statusStorage: statusStorage, kanjiFromApi: kanjiFromApi);
      },
      openColor: Theme.of(context).colorScheme.surface,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: Theme.of(context).colorScheme.surface,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: () {
            final isProcessingData = kanjiFromApi.statusStorage ==
                    StatusStorage.processingStoring ||
                kanjiFromApi.statusStorage == StatusStorage.processingDeleting;

            if (isProcessingData) return;

            ref
                .read(kanjiDetailsProvider.notifier)
                .initKanjiDetails(kanjiFromApi);

            //video player init

            VideoPlayerController videoController;

            if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
              videoController = VideoPlayerController.networkUrl(
                  Uri.parse(kanjiFromApi.videoLink));
            } else {
              videoController =
                  VideoPlayerController.file(File(kanjiFromApi.videoLink));
            }

            ref
                .read(videoPlayerObjectProvider.notifier)
                .setController(videoController);

            //open other screen

            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}
