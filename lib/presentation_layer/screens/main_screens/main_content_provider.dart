import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/pogress_screen/progress_screen_provider.dart';
import 'package:kanji_for_n5_level_app/utils/networking/networking.dart';

class MainScreenProvider extends Notifier<MainScreenData> {
  @override
  MainScreenData build() {
    return MainScreenData(
      selection: ScreenSelection.kanjiSections,
      avatarLink: '',
      fullName: '',
      pathAvatar: '',
    );
  }

  List<KanjiFromApi> listOfValidStoredKanjis = [];

  ScreenSelection getScreenSelection() {
    return state.selection;
  }

  void setFullName(String fullName) {
    state = MainScreenData(
      selection: state.selection,
      avatarLink: state.avatarLink,
      fullName: fullName,
      pathAvatar: state.pathAvatar,
    );
  }

  void setScreen(ScreenSelection screen) {
    state = MainScreenData(
      selection: screen,
      avatarLink: state.avatarLink,
      fullName: state.fullName,
      pathAvatar: state.pathAvatar,
    );
  }

  void setAvatarLink(String link) {
    state = MainScreenData(
      selection: state.selection,
      avatarLink: link,
      fullName: state.fullName,
      pathAvatar: state.pathAvatar,
    );
  }

  void setPathAvatar(String pathAvatar) {
    state = MainScreenData(
      selection: state.selection,
      avatarLink: state.avatarLink,
      fullName: state.fullName,
      pathAvatar: pathAvatar,
    );
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
          .getAllQuizSectionData(ref.read(authServiceProvider).userUuid ?? '');
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
    final listStoresKanjis =
        ref.read(storedKanjisProvider.notifier).listStoresKanjis;

    listOfValidStoredKanjis =
        listStoresKanjis.isEmpty ? await loadStoredKanjis() : listStoresKanjis;

    try {
      final quizScoreData = await ref
          .read(cloudDBServiceProvider)
          .loadQuizScoreData(ref.read(authServiceProvider).userUuid ?? '');
      ref.read(localDBServiceProvider).updateQuizScoreFromCloud(
          quizScoreData, ref.read(authServiceProvider).userUuid ?? '');
    } catch (e) {
      logger.e('error loading quiz score $e');
    }

    List<Favorite> favoritesKanjis = [];
    try {
      favoritesKanjis = await ref
          .read(cloudDBServiceProvider)
          .loadFavoritesCloudDB(ref.read(authServiceProvider).userUuid ?? '');
      await ref
          .read(localDBServiceProvider)
          .storeAllFavoritesFromCloud(favoritesKanjis);
    } catch (e) {
      favoritesKanjis = await ref
          .read(localDBServiceProvider)
          .loadFavoritesDatabase(ref.read(authServiceProvider).userUuid ?? '');
      logger.e('error loading favorites $e');
    }

    ref
        .read(favoriteskanjisProvider.notifier)
        .setInitialFavoritesWithInternetConnection(
            listOfValidStoredKanjis, favoritesKanjis, 10);
  }

  Future<void> getOfflineData() async {
    final listStoresKanjis =
        ref.read(storedKanjisProvider.notifier).listStoresKanjis;

    listOfValidStoredKanjis =
        listStoresKanjis.isEmpty ? await loadStoredKanjis() : listStoresKanjis;

    var kanjiFavoritesList =
        ref.read(favoriteskanjisProvider.notifier).getFavorites();

    if (kanjiFavoritesList.isNotEmpty) return;

    final favoritesKanjis = await ref
        .read(localDBServiceProvider)
        .loadFavoritesDatabase(ref.read(authServiceProvider).userUuid ?? '');
    ref
        .read(favoriteskanjisProvider.notifier)
        .setInitialFavoritesWithNoInternetConnection(
          listOfValidStoredKanjis,
          favoritesKanjis,
          10,
        );
  }

  Future<List<KanjiFromApi>> loadStoredKanjis() async {
    var listOfStoredKanjis = await ref
        .read(localDBServiceProvider)
        .loadStoredKanjis(ref.read(authServiceProvider).userUuid ?? '');
    final validAndInvalidKanjis = await runCompute(listOfStoredKanjis);
    final listOfValidStoredKanjis =
        validAndInvalidKanjis.$1.map((e) => e.$1).toList();
    final listOfInvalidStoredKanjis =
        validAndInvalidKanjis.$2.map((e) => e.$1).toList();
    ref
        .read(localDBServiceProvider)
        .cleanInvalidDBRecords(listOfInvalidStoredKanjis);

    ref
        .read(storedKanjisProvider.notifier)
        .setInitialStoredKanjis(listOfValidStoredKanjis);
    return listOfValidStoredKanjis;
  }

  Future<void> getAppBarData() async {
    final uuid = ref.read(authServiceProvider).userUuid;

    final userData =
        await ref.read(cloudDBServiceProvider).readUserData(uuid ?? '');
    final fullName = '${userData.firstName} ${userData.lastName}';

    try {
      if (state.avatarLink != '' && state.pathAvatar != '') return;

      final avatarLink =
          await ref.read(storageServiceProvider).getDownloadLink(uuid ?? '');

      final (_, pathAvatar) =
          await downloadAndCacheAvatar(uuid ?? '', avatarLink);

      state = MainScreenData(
          selection: ScreenSelection.kanjiSections,
          avatarLink: avatarLink,
          fullName: fullName,
          pathAvatar: pathAvatar);

      await ref.read(localDBServiceProvider).insertUserData({
        'uuid': uuid ?? '',
        'fullName': fullName,
        'linkAvatar': avatarLink,
        'pathAvatar': pathAvatar,
      });
    } catch (e) {
      logger.e('error reading profile photo');
      state = MainScreenData(
        selection: ScreenSelection.kanjiSections,
        avatarLink: '',
        fullName: fullName,
        pathAvatar: '',
      );
    }
  }

  Future<void> getAppBarDataOffline() async {
    logger.d(state.fullName);
    if (state.avatarLink == '' &&
        state.pathAvatar == '' &&
        state.fullName == '') {
      final listUser = await ref
          .read(localDBServiceProvider)
          .readUserData(ref.read(authServiceProvider).userUuid ?? '');
      if (listUser.isNotEmpty) {
        final user = listUser.first;
        state = MainScreenData(
          selection: ScreenSelection.kanjiSections,
          avatarLink: user['linkAvatar'] as String,
          fullName: user['fullName'] as String,
          pathAvatar: user['pathAvatar'] as String,
        );
      }
    }

    state = MainScreenData(
      selection: ScreenSelection.kanjiSections,
      avatarLink: state.avatarLink,
      fullName: state.fullName,
      pathAvatar: state.pathAvatar,
    );
  }

  void resetMainScreenState() {
    state = MainScreenData(
      selection: ScreenSelection.kanjiSections,
      avatarLink: '',
      fullName: '',
      pathAvatar: state.pathAvatar,
    );
  }
}

final mainScreenProvider = NotifierProvider<MainScreenProvider, MainScreenData>(
    MainScreenProvider.new);

class MainScreenData {
  final ScreenSelection selection;
  final String avatarLink;
  final String pathAvatar;
  final String fullName;

  MainScreenData({
    required this.selection,
    required this.avatarLink,
    required this.pathAvatar,
    required this.fullName,
  });
}

enum ScreenSelection {
  kanjiSections,
  favoritesKanjis,
  searchKanji,
  progressTimeLine
}

Future<(List<(KanjiFromApi, bool)>, List<(KanjiFromApi, bool)>)>
    cleanInvalidStoredFiles(
  List<KanjiFromApi> listOfStoredKanjis,
) async {
  final List<(KanjiFromApi, bool)> listKanjisRecords =
      listOfStoredKanjis.map((e) => (e, true)).toList();
  for (int i = 0; i < listKanjisRecords.length; i++) {
    var storedKanjiRecord = listKanjisRecords[i];
    final listExamples = storedKanjiRecord.$1.example;
    for (var example in listExamples) {
      var existAudioFile = await checkFileIfExists(example.audio.mp3);
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

Future<bool> checkFileIfExists(String path) async {
  final file = File(path);
  return await file.exists();
}
