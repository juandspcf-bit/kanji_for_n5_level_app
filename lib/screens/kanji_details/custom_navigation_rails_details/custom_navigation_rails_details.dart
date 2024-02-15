import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/landscape_screens/strokes.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/landscape_screens/video_strokes.dart';

class CustomNavigationRailKanjiDetails extends ConsumerWidget {
  const CustomNavigationRailKanjiDetails({
    super.key,
  });

  Widget getSelection(int selection) {
    if (selection == 0) {
      return const VideoStrolesLandScape();
    } else if (selection == 1) {
      return const StrokesLandScape();
    } else {
      return const Center(child: Text('audio examples'));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customNavigationRailsDetailsData =
        ref.watch(customNavigationRailsDetailsProvider);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: customNavigationRailsDetailsData.selection,
            groupAlignment: 0.0,
            onDestinationSelected: (int selection) {
              logger.d('selection $selection');
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
            ],
          ),
          Expanded(
              child: getSelection(customNavigationRailsDetailsData.selection)),
        ],
      ),
    );
  }
}
