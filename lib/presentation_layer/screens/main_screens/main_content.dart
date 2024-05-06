import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/account_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_rails/custom_navigation_rail.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/kanjis_for_favorites_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/pogress_screen/progress_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/sections_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainContent extends ConsumerWidget with StatusDBStoringDialogs {
  const MainContent({super.key});

  Widget selectScreen(ScreenSelection selectedPageIndex, WidgetRef ref) {
    getAllQuizSectionData(ref.read(authServiceProvider).userUuid ?? '');

    switch (selectedPageIndex) {
      case ScreenSelection.kanjiSections:
        return const Column(
          children: [
            Expanded(
              child: Sections(),
            ),
          ],
        );
      case ScreenSelection.favoritesKanjis:
        return const KanjisForFavoritesScreen();
      case ScreenSelection.searchKanji:
        return SearchScreen();

      case ScreenSelection.progressTimeLine:
        return const ProgressScreen();
      default:
        return const Center(
          child: Text("no screen"),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    bool bottomNavigationBar = true;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          bottomNavigationBar = false;
        }
      case (_, ScreenSizeWidth.extraLarge):
        bottomNavigationBar = true;
      case (_, ScreenSizeWidth.large):
        bottomNavigationBar = true;
      case (_, _):
        bottomNavigationBar = true;
    }

    final mainScreenData = ref.watch(mainScreenProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    String scaffoldTitle =
        '${AppLocalizations.of(context)!.welcome} \n ${mainScreenData.fullName}';

    if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
      scaffoldTitle = "Favorites";
    }

    ref.listen<ErrorDownloadKanji>(errorDownloadProvider, (previuos, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an errror downloading ${current.kanjiCharacter}");
    });

    ref.listen<ErrorDeleteKanji>(errorDeleteProvider, (previuos, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an errror deleting ${current.kanjiCharacter}");
    });

    return Scaffold(
      appBar: bottomNavigationBar
          ? AppBar(
              title: Text(scaffoldTitle),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: statusConnectionData == ConnectionStatus.noConnected
                      ? const Icon(Icons.cloud_off)
                      : const Icon(Icons.cloud_done_rounded),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
                        reverseTransitionDuration: const Duration(seconds: 1),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const AccountDetails(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(
                              animation.drive(
                                CurveTween(
                                  curve: Curves.easeInOutBack,
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: LayoutBuilder(
                    builder: (ctx, constrains) {
                      final height = constrains.maxHeight;
                      return (mainScreenData.avatarLink != '' &&
                              mainScreenData.pathAvatar != '')
                          ? Container(
                              color: Colors.transparent,
                              width: height - 3,
                              height: height - 3,
                              child: CircleAvatar(
                                backgroundImage:
                                    FileImage(File(mainScreenData.pathAvatar)),
                              ),
                            )
                          : CachedNetworkImage(
                              width: height - 3,
                              height: height - 3,
                              fit: BoxFit.cover,
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  backgroundImage: imageProvider,
                                );
                              },
                              imageUrl: mainScreenData.avatarLink,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/user.png'),
                            );
                    },
                  ),
                ),
              ],
            )
          : null,
      body: bottomNavigationBar
          ? selectScreen(mainScreenData.selection, ref)
          : Row(
              children: [
                const CustomNavigationRail(),
                Expanded(
                  child: selectScreen(mainScreenData.selection, ref),
                )
              ],
            ),
      bottomNavigationBar:
          bottomNavigationBar ? const CustomBottomNavigationBar() : null,
    );
  }
}
