import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/pogress_screen/progress_screen_provider.dart';

class MainScreenProvider extends Notifier<MainScreenData> {
  @override
  MainScreenData build() {
    Connectivity().checkConnectivity().then((result) =>
        ref.read(statusConnectionProvider.notifier).setInitialStatus(result));
    return MainScreenData(
        selection: ScreenSelection.kanjiSections, avatarLink: '', fullName: '');
  }

  void setScreen(ScreenSelection screen) {
    state = MainScreenData(
        selection: screen,
        avatarLink: state.avatarLink,
        fullName: state.fullName);
  }

  void setAvatarLink(String link) {
    state = MainScreenData(
        selection: state.selection, avatarLink: link, fullName: state.fullName);
  }

  ScreenSelection getScreenSelection() {
    return state.selection;
  }

  void setLinkAvatar(String link) {
    state = MainScreenData(
        selection: state.selection, avatarLink: link, fullName: state.fullName);
  }

  void selectPage(
    int index,
    BuildContext context,
    void Function(BuildContext context) scaleDialog,
  ) {
    if (index == 0) {
      ref
          .read(mainScreenProvider.notifier)
          .setScreen(ScreenSelection.kanjiSections);
    } else if (index == 1) {
      ref
          .read(mainScreenProvider.notifier)
          .setScreen(ScreenSelection.favoritesKanjis);
    } else if (index == 2) {
      ref
          .read(mainScreenProvider.notifier)
          .setScreen(ScreenSelection.searchKanji);
    } else {
      ref
          .read(progressTimelineProvider.notifier)
          .getAllQuizSectionData(authService.userUuid ?? '');
      ref
          .read(mainScreenProvider.notifier)
          .setScreen(ScreenSelection.progressTimeLine);
    }
  }

  Future<(List<(KanjiFromApi, bool)>, List<(KanjiFromApi, bool)>)> runCompute(
      List<KanjiFromApi> listOfStoredKanjis) async {
    return await compute(cleanInvalidStoredFiles, listOfStoredKanjis);
  }

  ///edpoint where the app is initilizated with online connection
  Future<void> initAppOnline() async {
    await getOnlineData();
    await getAppBarData();
  }

  Future<void> initAppOffline() async {
    await getOfflineData();
    await getAppBarDataOffline();
  }

  Future<void> getOnlineData() async {
    List<KanjiFromApi> listOfValidStoredKanjis = await loadStoredKanjis();

    try {
      final quizScoreData =
          await cloudDBService.loadQuizScoreData(authService.userUuid ?? '');
      localDBService.updateQuizScoreFromCloud(
          quizScoreData, authService.userUuid ?? '');
    } catch (e) {
      logger.e('error loading quiz score $e');
    }

    List<Favorite> favoritesKanjis;
    try {
      favoritesKanjis =
          await cloudDBService.loadFavoritesCloudDB(authService.userUuid ?? '');
      await localDBService.storeAllFavoritesFromCloud(favoritesKanjis);
    } catch (e) {
      favoritesKanjis = [];
      logger.e('error loading favorites $e');
    }

    ref
        .read(favoriteskanjisProvider.notifier)
        .setInitialFavoritesWithInternetConnection(
            listOfValidStoredKanjis, favoritesKanjis, 10);
  }

  Future<void> getOfflineData() async {
    List<KanjiFromApi> listOfValidStoredKanjis = await loadStoredKanjis();
    final favoritesKanjis =
        await localDBService.loadFavoritesDatabase(authService.userUuid ?? '');
    ref
        .read(favoriteskanjisProvider.notifier)
        .setInitialFavoritesWithNoInternetConnection(
            listOfValidStoredKanjis, favoritesKanjis, 10);
  }

  Future<List<KanjiFromApi>> loadStoredKanjis() async {
    var listOfStoredKanjis = await localDBService.loadStoredKanjis();
    final validAndInvalidKanjis = await runCompute(listOfStoredKanjis);
    final listOfValidStoredKanjis =
        validAndInvalidKanjis.$1.map((e) => e.$1).toList();
    final listOfInvalidStoredKanjis =
        validAndInvalidKanjis.$2.map((e) => e.$1).toList();
    localDBService.cleanInvalidDBRecords(listOfInvalidStoredKanjis);
    ref.read(lottieFilesProvider.notifier).initLottieFile();

    ref
        .read(storedKanjisProvider.notifier)
        .setInitialStoredKanjis(listOfValidStoredKanjis);
    return listOfValidStoredKanjis;
  }

  Future<void> getAppBarData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    try {
      final link = await storageService.getDownloadLink(uuid);
      state = MainScreenData(
          selection: ScreenSelection.kanjiSections,
          avatarLink: link,
          fullName: fullName ?? '');
    } catch (e) {
      logger.e('error reading profile photo');
      state = MainScreenData(
          selection: ScreenSelection.kanjiSections,
          avatarLink: '',
          fullName: fullName ?? '');
    }
  }

  Future<void> getAppBarDataOffline() async {
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    logger.d('The full name is 1 $fullName');

    state = MainScreenData(
        selection: ScreenSelection.kanjiSections,
        avatarLink: '',
        fullName: fullName ?? '');
  }

  void resetMainScreenState() {
    state = MainScreenData(
        selection: ScreenSelection.kanjiSections, avatarLink: '', fullName: '');
  }
}

final mainScreenProvider = NotifierProvider<MainScreenProvider, MainScreenData>(
    MainScreenProvider.new);

class MainScreenData {
  final ScreenSelection selection;
  final String avatarLink;
  final String fullName;

  MainScreenData(
      {required this.selection,
      required this.avatarLink,
      required this.fullName});
}

enum ScreenSelection {
  kanjiSections,
  favoritesKanjis,
  searchKanji,
  progressTimeLine
}

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

Future<bool> checkFileIfExists(String audioPath) async {
  final audioFile = File(audioPath);
  return await audioFile.exists();
}
