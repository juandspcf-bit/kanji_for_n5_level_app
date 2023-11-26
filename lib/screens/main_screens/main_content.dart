import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/providers/selection_navigation_bar_screen.dart';
import 'package:kanji_for_n5_level_app/screens/favorite_screen.dart';
import 'package:kanji_for_n5_level_app/screens/sections_screen.dart';
import 'package:logger/logger.dart';

Dio dio = Dio();
final logger = Logger();

class MainContent extends ConsumerWidget {
  const MainContent({super.key, required this.uuid});

  final String uuid;

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

      default:
        return const Center(
          child: Text("no screen"),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStateMainContent = ref.watch(mainScreenProvider);

    String scaffoldTitle = 'Welcome \n ${dataStateMainContent.fullName}';

    if (dataStateMainContent.selection == 1) scaffoldTitle = "Favorites";

    final sizeScreen = getScreenSize(context);
    double iconSize;
    switch (sizeScreen) {
      case ScreenSize.extraLarge:
        iconSize = 60;
      case ScreenSize.large:
        iconSize = 40;
      case _:
        iconSize = 30;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(scaffoldTitle),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ref.read(mainScreenProvider.notifier).resetMainScreenState();
              },
              icon: const Icon(Icons.logout)),
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                imageUrl: dataStateMainContent.avatarLink,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/user.png'),
              ),
            ),
          ),
        ],
      ),
      body: selectScreen(dataStateMainContent.selection),
      bottomNavigationBar: CustomBottomNavigationBar(
        iconSize: iconSize,
        selectPage: (index) {
          ref
              .read(mainScreenProvider.notifier)
              .selectPage(index, context, _scaleDialog);
        },
        selectedPageIndex: dataStateMainContent.selection,
      ),
    );
  }
}
