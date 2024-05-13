import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/title_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/account_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_rails/custom_navigation_rail.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/kanjis_for_favorites_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/progress_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/sections_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

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

    ref.listen<ErrorDownloadKanji>(errorDownloadProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an error downloading ${current.kanjiCharacter}");
    });

    ref.listen<ErrorDeleteKanji>(errorDeleteProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an error deleting ${current.kanjiCharacter}");
    });

    return Scaffold(
      appBar: bottomNavigationBar
          ? AppBar(
              title: mainScreenData.selection == ScreenSelection.favoritesKanjis
                  ? const Text("Favorites")
                  : const TitleMainScreen(),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: statusConnectionData == ConnectionStatus.noConnected
                      ? const Icon(Icons.cloud_off)
                      : const Icon(Icons.cloud_done_rounded),
                ),
                const AvatarMainScreen(),
                const SizedBox(
                  width: 5,
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

class AvatarMainScreen extends ConsumerWidget {
  const AvatarMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarLink = ref.watch(avatarMainScreenProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return avatarLink.when(
          data: (data) {
            final (connection, url) = data;
            return GestureDetector(
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
              child: (connection == ConnectionStatus.noConnected)
                  ? Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: constraints.maxHeight - 5,
                        height: constraints.maxHeight - 5,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: CircleAvatar(
                            backgroundImage: FileImage(File(url)),
                          ),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageBuilder: (context, imageProvider) {
                        return SizedBox(
                          width: constraints.maxHeight - 5,
                          height: constraints.maxHeight - 5,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                          ),
                        );
                      },
                      imageUrl: url,
                      placeholder: (context, url) => SizedBox(
                            width: constraints.maxHeight - 5,
                            height: constraints.maxHeight - 5,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) => SizedBox(
                            width: constraints.maxHeight - 5,
                            height: constraints.maxHeight - 5,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Image.asset('assets/images/user.png'),
                            ),
                          )),
            );
          },
          error: (error, stack) => Container(),
          loading: () => SizedBox(
            width: constraints.maxHeight,
            height: constraints.maxHeight,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class TitleMainScreen extends ConsumerWidget {
  const TitleMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleMainScreenData = ref.watch(titleMainScreenProvider);
    return titleMainScreenData.when(
      data: (data) => Text('${context.l10n.welcome} \n $data'),
      error: (error, stack) => Container(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
