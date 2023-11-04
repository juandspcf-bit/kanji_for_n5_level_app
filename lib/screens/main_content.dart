import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/favorite_screen.dart';
import 'package:kanji_for_n5_level_app/screens/sections_screen.dart';

const temporalAvatar =
    "https://firebasestorage.googleapis.com/v0/b/kanji-for-n5.appspot.com/o/unnamed.jpg?alt=media&token=38275fec-42f3-4d95-b1fd-785e82d4086f&_gl=1*19p8v1f*_ga*MjAyNTg0OTcyOS4xNjk2NDEwODIz*_ga_CW55HF8NVT*MTY5NzEwMTY3NC45LjEuMTY5NzEwMzExMy4zMy4wLjA.";

Dio dio = Dio();

void cleanStoredFiles(List<KanjiFromApi> listOfStoredKanjis) async {
  final List<KanjiFromApi> listKanjisOk = [];
  final List<KanjiFromApi> listKanjisNotOk = [];
  for (var storedKanji in listOfStoredKanjis) {
    final listExamples = storedKanji.example;
    for (var example in listExamples) {
      final opusPath = example.audio.opus;
      final opusFile = File(opusPath);
      final existOpusFile = await opusFile.exists();
      if (!existOpusFile) {
        listKanjisNotOk.add(storedKanji);
        break;
      }
    }
  }
}

class MainContent extends ConsumerStatefulWidget {
  const MainContent({super.key});

  @override
  ConsumerState<MainContent> createState() => _MainContentState();
}

class _MainContentState extends ConsumerState<MainContent> {
  int _selectedPageIndex = 0;

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

  void _scaleDialog() {
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

  bool isAnyProcessingData() {
    final listFavorites = ref.read(favoritesCachedProvider);
    try {
      listFavorites.$1.firstWhere(
        (element) =>
            element.statusStorage == StatusStorage.proccessingStoring ||
            element.statusStorage == StatusStorage.proccessingDeleting,
      );

      return true;
    } on StateError {
      return false;
    }
  }

  void _selectPage(int index) {
    setState(() {
      if (index == 0 && isAnyProcessingData()) {
        _scaleDialog();
        return;
      }

      if (index == 1) {
        ref.read(favoriteScreenSelectionProvider.notifier).setSelection();
      } else {
        ref.read(favoriteScreenSelectionProvider.notifier).setNotSelection();
      }

      _selectedPageIndex = index;
    });
  }

  void getInitData() async {
    final listOfStoredKanjis = await loadStoredKanjis();

    ref
        .read(statusStorageProvider.notifier)
        .setInitialStoredKanjis(listOfStoredKanjis);
    final favoritesKanjis = await loadFavorites();
    Connectivity().checkConnectivity().then((result) {
      if (ConnectivityResult.none == result) {
        ref.read(favoritesCachedProvider.notifier).setInitialFavoritesOffline(
            listOfStoredKanjis, favoritesKanjis, 10);
      } else {
        ref
            .read(favoritesCachedProvider.notifier)
            .setInitialFavoritesOnline(listOfStoredKanjis, favoritesKanjis, 10);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getInitData();
    Connectivity().checkConnectivity().then((result) =>
        ref.read(statusConnectionProvider.notifier).setInitialStatus(result));
/*     subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print(result);
    }); */
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
  Widget build(BuildContext context) {
    String scaffoldTitle = "Welcome juan";
    if (_selectedPageIndex == 1) scaffoldTitle = "Favorites";

    return Scaffold(
      appBar: AppBar(
        title: Text(scaffoldTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                imageUrl: temporalAvatar,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
      body: selectScreen(_selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(100),
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Sections",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
