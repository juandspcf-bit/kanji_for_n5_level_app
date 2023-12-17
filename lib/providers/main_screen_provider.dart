import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_loading_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_favorites.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class MainScreenProvider extends Notifier<MainScreenData> {
  @override
  MainScreenData build() {
    //getInitData();

    Connectivity().checkConnectivity().then((result) =>
        ref.read(statusConnectionProvider.notifier).setInitialStatus(result));
    //getAvatar();
    return MainScreenData(selection: 0, avatarLink: '', fullName: '');
  }

  void setScreen(int screen) {
    state = MainScreenData(
        selection: screen,
        avatarLink: state.avatarLink,
        fullName: state.fullName);
  }

  void setAvatarLink(String link) {
    state = MainScreenData(
        selection: state.selection, avatarLink: link, fullName: state.fullName);
  }

  int getScreenSelection() {
    return state.selection;
  }

  bool isAnyProcessingData() {
    final listFavorites = ref.read(favoriteskanjisProvider);
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

  void setLinkAvatar(String link) {
    state = MainScreenData(
        selection: state.selection, avatarLink: link, fullName: state.fullName);
  }

  void selectPage(int index, BuildContext context,
      void Function(BuildContext context) scaleDialog) {
    if (index == 0 && isAnyProcessingData()) {
      scaleDialog(context);
      return;
    }

    if (index == 0) {
      ref.read(mainScreenProvider.notifier).setScreen(0);
    } else if (index == 1) {
      ref.read(mainScreenProvider.notifier).setScreen(1);
    } else {
      ref.read(mainScreenProvider.notifier).setScreen(2);
    }
  }

  Future<(List<(KanjiFromApi, bool)>, List<(KanjiFromApi, bool)>)> runCompute(
      List<KanjiFromApi> listOfStoredKanjis) async {
    return await compute(cleanInvalidStoredFiles, listOfStoredKanjis);
  }

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
    final favoritesKanjis = await loadFavorites();
    ref.read(favoriteskanjisProvider.notifier).setInitialFavoritesOnline(
        listOfValidStoredKanjis, favoritesKanjis, 10);
  }

  Future<void> getOfflineData() async {
    List<KanjiFromApi> listOfValidStoredKanjis = await loadStoredKanjis();
    final favoritesKanjis = await loadFavorites();
    ref.read(favoriteskanjisProvider.notifier).setInitialFavoritesOffline(
        listOfValidStoredKanjis, favoritesKanjis, 10);
  }

  Future<List<KanjiFromApi>> loadStoredKanjis() async {
    var listOfStoredKanjis = await loadStoredKanjisFromDB();
    final validAndInvalidKanjis = await runCompute(listOfStoredKanjis);
    final listOfValidStoredKanjis =
        validAndInvalidKanjis.$1.map((e) => e.$1).toList();
    final listOfInvalidStoredKanjis =
        validAndInvalidKanjis.$2.map((e) => e.$1).toList();
    cleanInvaliDbRecords(listOfInvalidStoredKanjis);
    ref.read(lottieFilesProvider.notifier).initLottieFile();

    ref
        .read(storedKanjisProvider.notifier)
        .setInitialStoredKanjis(listOfValidStoredKanjis);
    return listOfValidStoredKanjis;
  }

  Future<void> getAppBarData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    logger.d('The full name is 1 $fullName');

    try {
      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      final link = await userPhoto.getDownloadURL();
      logger.d(link);
      state = MainScreenData(
          selection: 0, avatarLink: link, fullName: fullName ?? '');
    } catch (e) {
      logger.e('error reading profile photo');
      logger.d('The full name is 2 $fullName');
      state = MainScreenData(
          selection: 0, avatarLink: '', fullName: fullName ?? '');
    }
  }

  Future<void> getAppBarDataOffline() async {
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    logger.d('The full name is 1 $fullName');

    state =
        MainScreenData(selection: 0, avatarLink: '', fullName: fullName ?? '');
  }

  void resetMainScreenState() {
    state = MainScreenData(selection: 0, avatarLink: '', fullName: '');
  }
}

final mainScreenProvider = NotifierProvider<MainScreenProvider, MainScreenData>(
    MainScreenProvider.new);

class MainScreenData {
  final int selection;
  final String avatarLink;
  final String fullName;

  MainScreenData(
      {required this.selection,
      required this.avatarLink,
      required this.fullName});
}

enum ScreenSelection { kanjiSections, favoritesKanjis }

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
