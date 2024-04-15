import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kaji_details_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/examples_audios_status_playing_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/image_meaning_kanji_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';

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
                    StatusStorage.proccessingStoring ||
                kanjiFromApi.statusStorage == StatusStorage.proccessingDeleting;

            if (isProcessingData) return;

            ref
                .read(customNavigationRailsDetailsProvider.notifier)
                .setSelection(0);
            ref.read(videoStatusPlaying.notifier).setSpeed(1.0);
            ref.read(videoStatusPlaying.notifier).setIsPlaying(true);
            var queryKanji = ref
                .read(favoriteskanjisProvider.notifier)
                .searchInFavorites(kanjiFromApi.kanjiCharacter);
            final favoriteStatus = queryKanji;
            ref.read(kanjiDetailsProvider.notifier).setInitValues(
                kanjiFromApi, kanjiFromApi.statusStorage, favoriteStatus);
            ref.read(examplesAudiosTrackListProvider).assetsAudioPlayer.stop();
            ref
                .read(examplesAudiosTrackListProvider.notifier)
                .setIsPlaying(false);

            ref.read(imageMeaningKanjiProvider.notifier).clearState();
            ref
                .read(imageMeaningKanjiProvider.notifier)
                .fetchData(kanjiFromApi.kanjiCharacter);

            ref
                .read(examplesAudiosPlayingAudioProvider.notifier)
                .setInitList(kanjiFromApi);
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}
