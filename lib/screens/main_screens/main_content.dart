import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/account_details.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/sections_screen.dart';
import 'package:logger/logger.dart';

Dio dio = Dio();
final logger = Logger();

class MainContent extends ConsumerWidget {
  const MainContent({super.key});

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Please wait!!"),
      content: const Text('Please wait until all the operations are completed'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget selectScreen(int selectedPageIndex) {
    switch (selectedPageIndex) {
      case 0:
        return const Column(
          children: [
            Expanded(
              child: Sections(),
            ),
          ],
        );
      case 1:
        return const FavoriteScreen();
      case 2:
        return SearchScreen();

      default:
        return const Center(
          child: Text("no screen"),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    String scaffoldTitle = 'Welcome \n ${mainScreenData.fullName}';

    if (mainScreenData.selection == 1) scaffoldTitle = "Favorites";

    final sizeScreen = getScreenSizeWidth(context);
    double iconSize;
    switch (sizeScreen) {
      case ScreenSizeWidth.extraLarge:
        iconSize = 60;
      case ScreenSizeWidth.large:
        iconSize = 40;
      case _:
        iconSize = 30;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(scaffoldTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: statusConnectionData == ConnectivityResult.none
                ? const Icon(Icons.cloud_off)
                : const Icon(Icons.cloud_done_rounded),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const AccountDetails();
              }));
            },
            child: LayoutBuilder(
              builder: (ctx, constrains) {
                final height = constrains.maxHeight;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    width: height - 3,
                    height: height - 3,
                    fit: BoxFit.cover,
                    imageUrl: mainScreenData.avatarLink,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/user.png'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: selectScreen(mainScreenData.selection),
      bottomNavigationBar: CustomBottomNavigationBar(
        iconSize: iconSize,
        selectPage: (index) {
          ref
              .read(mainScreenProvider.notifier)
              .selectPage(index, context, _scaleDialog);
        },
        selectedPageIndex: mainScreenData.selection,
      ),
    );
  }
}
