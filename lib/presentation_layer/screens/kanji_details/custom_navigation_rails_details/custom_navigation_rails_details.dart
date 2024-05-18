import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/examples_ladscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/options.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/strokes.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/video_strokes_landscape.dart';

class CustomNavigationRailKanjiDetails extends ConsumerWidget {
  const CustomNavigationRailKanjiDetails({
    super.key,
  });

  Widget getSelection(
    int selection,
    KanjiFromApi kanjiFromApi,
  ) {
    if (selection == 0) {
      return const VideoStrokesLandScape();
    } else if (selection == 1) {
      return const StrokesLandScape();
    } else if (selection == 2) {
      return const ExamplesLandscape();
    } else {
      return OptionsDetails(
        kanjiFromApi: kanjiFromApi,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiFromApi = ref.read(kanjiDetailsProvider)!.kanjiFromApi;
    final customNavigationRailsDetailsData =
        ref.watch(customNavigationRailsDetailsProvider);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: customNavigationRailsDetailsData.selection,
            groupAlignment: 0.0,
            onDestinationSelected: (int selection) {
              ref
                  .read(customNavigationRailsDetailsProvider.notifier)
                  .setSelection(selection);
            },
            labelType: NavigationRailLabelType.none,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.movie),
                label: Text('movie'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.draw),
                label: Text('draw'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.play_lesson),
                label: Text('Play lesson'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu),
                label: Text('options'),
              ),
            ],
          ),
          Expanded(
              child: getSelection(
            customNavigationRailsDetailsData.selection,
            kanjiFromApi,
          )),
        ],
      ),
    );
  }
}
