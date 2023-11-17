import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/selection_navigation_bar_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/favorite_screen.dart';
import 'package:kanji_for_n5_level_app/screens/sections_screen.dart';
import 'package:logger/logger.dart';

const temporalAvatar =
    "https://firebasestorage.googleapis.com/v0/b/kanji-for-n5.appspot.com/o/unnamed.jpg?alt=media&token=38275fec-42f3-4d95-b1fd-785e82d4086f&_gl=1*19p8v1f*_ga*MjAyNTg0OTcyOS4xNjk2NDEwODIz*_ga_CW55HF8NVT*MTY5NzEwMTY3NC45LjEuMTY5NzEwMzExMy4zMy4wLjA.";

Dio dio = Dio();
final logger = Logger();

Future<(List<(KanjiFromApi, bool)>, List<(KanjiFromApi, bool)>)>
    cleanInvalidStoredFiles(List<KanjiFromApi> listOfStoredKanjis) async {
  final List<(KanjiFromApi, bool)> listKanjisRecords =
      listOfStoredKanjis.map((e) => (e, true)).toList();
  for (int i = 0; i < listKanjisRecords.length; i++) {
    var storedKanjiRecord = listKanjisRecords[i];
    final listExamples = storedKanjiRecord.$1.example;
    for (var example in listExamples) {
      var existAudioFile = await checkFileIfExists(example.audio.opus);
      if (!existAudioFile) {
        storedKanjiRecord = (storedKanjiRecord.$1, false);
        break;
      }

      existAudioFile = await checkFileIfExists(example.audio.aac);
      if (!existAudioFile) {
        storedKanjiRecord = (storedKanjiRecord.$1, false);
        break;
      }

      existAudioFile = await checkFileIfExists(example.audio.ogg);
      if (!existAudioFile) {
        storedKanjiRecord = (storedKanjiRecord.$1, false);
        break;
      }

      existAudioFile = await checkFileIfExists(example.audio.mp3);
      if (!existAudioFile) {
        storedKanjiRecord = (storedKanjiRecord.$1, false);
        break;
      }
    }
    if (!storedKanjiRecord.$2) {
      continue;
    }

    final listStrokes = storedKanjiRecord.$1.strokes.images;
    for (var i = 0; i < listStrokes.length; i++) {
      var existStrokeFile = await checkFileIfExists(listStrokes[i]);
      if (!existStrokeFile) {
        storedKanjiRecord = (storedKanjiRecord.$1, false);
        break;
      }
    }

    if (!storedKanjiRecord.$2) {
      continue;
    }

    var existVideoFile =
        await checkFileIfExists(storedKanjiRecord.$1.videoLink);
    if (!existVideoFile) {
      storedKanjiRecord = (storedKanjiRecord.$1, false);
      break;
    }

    var existImageFile =
        await checkFileIfExists(storedKanjiRecord.$1.kanjiImageLink);
    if (!existImageFile) {
      storedKanjiRecord = (storedKanjiRecord.$1, false);
      break;
    }
  }

  return (
    listKanjisRecords.where((element) => element.$2 == true).toList(),
    listKanjisRecords.where((element) => element.$2 == false).toList()
  );
}

Future<void> cleanInvaliDbRecords(
    List<KanjiFromApi> listOfInavlidKanjis) async {
  final db = await kanjiFromApiDatabase;

  for (var kanjiFromApi in listOfInavlidKanjis) {
    await db.rawDelete('DELETE FROM kanji_FromApi WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await db.rawDelete('DELETE FROM examples WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await db.rawDelete('DELETE FROM strokes WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
  }
}

Future<bool> checkFileIfExists(String audioPath) async {
  final audioFile = File(audioPath);
  return await audioFile.exists();
}

class MainContent extends ConsumerStatefulWidget {
  const MainContent({super.key});

  @override
  ConsumerState<MainContent> createState() => _MainContentState();
}

class _MainContentState extends ConsumerState<MainContent> {
  Future<(List<(KanjiFromApi, bool)>, List<(KanjiFromApi, bool)>)> runCompute(
      List<KanjiFromApi> listOfStoredKanjis) async {
    return await compute(cleanInvalidStoredFiles, listOfStoredKanjis);
  }

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
    final listFavorites = ref.read(favoritesListProvider);
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
    if (index == 0 && isAnyProcessingData()) {
      _scaleDialog();
      return;
    }

    if (index == 1) {
      ref.read(selectionNavigationBarScreen.notifier).setScreen(1);
    } else {
      ref.read(selectionNavigationBarScreen.notifier).setScreen(0);
    }
  }

  void getInitData() async {
    var listOfStoredKanjis = await loadStoredKanjis();
    final validAndInvalidKanjis = await runCompute(listOfStoredKanjis);
    logger
        .d('${listOfStoredKanjis.length} : ${validAndInvalidKanjis.$1.length}');
    final listOfValidStoredKanjis =
        validAndInvalidKanjis.$1.map((e) => e.$1).toList();
    final listOfInvalidStoredKanjis =
        validAndInvalidKanjis.$2.map((e) => e.$1).toList();
    cleanInvaliDbRecords(listOfInvalidStoredKanjis);
    FlutterNativeSplash.remove();

    ref
        .read(statusStorageProvider.notifier)
        .setInitialStoredKanjis(listOfValidStoredKanjis);
    final favoritesKanjis = await loadFavorites();
    Connectivity().checkConnectivity().then((result) {
      if (ConnectivityResult.none == result) {
        ref.read(favoritesListProvider.notifier).setInitialFavoritesOffline(
            listOfValidStoredKanjis, favoritesKanjis, 10);
      } else {
        ref.read(favoritesListProvider.notifier).setInitialFavoritesOnline(
            listOfValidStoredKanjis, favoritesKanjis, 10);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getInitData();
    Connectivity().checkConnectivity().then((result) =>
        ref.read(statusConnectionProvider.notifier).setInitialStatus(result));
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
    final selectedPageIndex = ref.watch(selectionNavigationBarScreen);
    if (selectedPageIndex == 1) scaffoldTitle = "Favorites";

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
      body: selectScreen(selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedItemColor: Theme.of(context).colorScheme.onSecondaryContainer,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSecondaryContainer.withAlpha(100),
        onTap: _selectPage,
        currentIndex: selectedPageIndex,
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
