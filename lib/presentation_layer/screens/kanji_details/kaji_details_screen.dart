import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/custom_tab_controller.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiDetails extends ConsumerWidget {
  const KanjiDetails(
      {super.key, required this.kanjiFromApi, required this.statusStorage});

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  String capitalizeString(String text) {
    var firstLetter = text[0];
    firstLetter = firstLetter.toUpperCase();
    return firstLetter + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    bool tabScreen = true;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          tabScreen = false;
        }
      case (_, ScreenSizeWidth.extraLarge):
        tabScreen = true;
      case (_, ScreenSizeWidth.large):
        tabScreen = true;
      case (_, _):
        tabScreen = true;
    }

    ref.listen<KanjiDetailsData?>(kanjiDetailsProvider, (prev, current) {
      if (current!.storingToFavoritesStatus ==
              StoringToFavoritesStatus.successAdded ||
          current.storingToFavoritesStatus ==
              StoringToFavoritesStatus.successRemoved ||
          current.storingToFavoritesStatus == StoringToFavoritesStatus.error) {
        ref.read(toastServiceProvider).dismiss(context);
        ref.read(toastServiceProvider).showShortMessage(
            context, current.storingToFavoritesStatus.message);

        ref
            .read(kanjiDetailsProvider.notifier)
            .setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    });

    return tabScreen
        ? const CustomTabControllerKanjiDetails()
        : const CustomNavigationRailKanjiDetails();
  }
}
