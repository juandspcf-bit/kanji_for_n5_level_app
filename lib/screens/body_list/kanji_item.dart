// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/image_meaning_kanji_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/title_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/trailing_tile.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kaji_details_screen.dart';

class KanjiItem extends ConsumerStatefulWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<KanjiItem> createState() => _KanjiItemState();
}

class _KanjiItemState extends ConsumerState<KanjiItem> {
  var accessToKanjiItemsButtons = true;

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    ref.read(customNavigationRailsDetailsProvider.notifier).setSelection(0);
    ref.read(videoStatusPlaying.notifier).setSpeed(1.0);
    ref.read(videoStatusPlaying.notifier).setIsPlaying(true);
    var queryKanji = ref
        .read(favoriteskanjisProvider.notifier)
        .searchInFavorites(widget.kanjiFromApi.kanjiCharacter);
    final favoriteStatus = queryKanji;
    ref.read(kanjiDetailsProvider.notifier).setInitValues(
        kanjiFromApi, kanjiFromApi.statusStorage, favoriteStatus);
    ref.read(examplesAudiosProvider).assetsAudioPlayer.stop();
    ref.read(examplesAudiosProvider.notifier).setIsPlaying(false);

    ref.read(imageMeaningKanjiProvider.notifier).clearState();
    ref
        .read(imageMeaningKanjiProvider.notifier)
        .fetchData(kanjiFromApi.kanjiCharacter);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
          statusStorage: kanjiFromApi.statusStorage,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.kanjiFromApi.accessToKanjiItemsButtons
          ? () {
              logger.d('clicked');
              navigateToKanjiDetails(context, widget.kanjiFromApi);
            }
          : null,
      child: Card(
        color: accessToKanjiItemsButtons
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).cardColor.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LeadingTile(
                kanjiFromApi: widget.kanjiFromApi,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: widget.kanjiFromApi.accessToKanjiItemsButtons
                        ? () {
                            navigateToKanjiDetails(
                                context, widget.kanjiFromApi);
                          }
                        : null,
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTile(
                            kanjiFromApi: widget.kanjiFromApi,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SubTitleTile(
                            kanjiFromApi: widget.kanjiFromApi,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: TrailingTile(
                  kanjiFromApi: widget.kanjiFromApi,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
