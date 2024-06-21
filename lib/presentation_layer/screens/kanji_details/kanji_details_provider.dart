import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/custom_navigation_rails_details/custom_navigation_rails_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/examples_audios_status_playing_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_strokes/pdf_strokes/pdf_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_strokes/pdf_strokes/save_and_open_pdf.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/examples_audios_track_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/download_data_handlers.dart';

class KanjiDetailsProvider extends Notifier<KanjiDetailsData?> {
  @override
  KanjiDetailsData? build() {
    return null;
  }

  void setInitValues(
    KanjiFromApi kanjiFromApi,
    StatusStorage statusStorage,
    bool favoriteStatus,
  ) {
    state = KanjiDetailsData(
        favoriteStatus: favoriteStatus,
        kanjiFromApi: kanjiFromApi,
        statusStorage: statusStorage,
        storingToFavoritesStatus: StoringToFavoritesStatus.noStarted);
  }

  void setFavoritesStatusInKanjiDetailsData(bool value) {
    state = KanjiDetailsData(
        favoriteStatus: value,
        kanjiFromApi: state!.kanjiFromApi,
        statusStorage: state!.statusStorage,
        storingToFavoritesStatus: state!.storingToFavoritesStatus);
  }

  void setStoringToFavoritesStatus(
      StoringToFavoritesStatus storingToFavoritesStatus) {
    state = KanjiDetailsData(
      favoriteStatus: state!.favoriteStatus,
      kanjiFromApi: state!.kanjiFromApi,
      statusStorage: state!.statusStorage,
      storingToFavoritesStatus: storingToFavoritesStatus,
    );
  }

  ///initial point function for storing or deleting a kanji in favorites
  void storeToFavorites(KanjiFromApi kanjiFromApi) async {
    setStoringToFavoritesStatus(StoringToFavoritesStatus.processing);
    final queryKanji = ref
        .read(favoritesKanjisProvider.notifier)
        .searchInFavorites(kanjiFromApi.kanjiCharacter);

    if (!queryKanji) {
      try {
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        await ref.read(cloudDBServiceProvider).insertFavoriteCloudDB(
              kanjiFromApi.kanjiCharacter,
              timeStamp,
              ref.read(authServiceProvider).userUuid ?? '',
            );
        await ref
            .read(localDBServiceProvider)
            .insertFavorite(kanjiFromApi.kanjiCharacter, timeStamp);
        final storedItems =
            ref.read(storedKanjisProvider.notifier).getStoresItems();
        ref.read(favoritesKanjisProvider.notifier).addItem(
            storedItems.values.fold(
              [],
              (previousValue, element) {
                previousValue.addAll(element);
                return previousValue;
              },
            ),
            FavoriteKanji(kanjiFromApi: kanjiFromApi, timeStamp: timeStamp));
        Future.delayed(
          const Duration(
            seconds: 1,
          ),
          () {
            setStoringToFavoritesStatus(StoringToFavoritesStatus.successAdded);
            setFavoritesStatusInKanjiDetailsData(!queryKanji);
          },
        );
      } catch (e) {
        logger.e(e);
        setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    } else {
      try {
        await ref.read(cloudDBServiceProvider).deleteFavoriteCloudDB(
              kanjiFromApi.kanjiCharacter,
              ref.read(authServiceProvider).userUuid ?? '',
            );
        await ref
            .read(localDBServiceProvider)
            .deleteFavorite(kanjiFromApi.kanjiCharacter);
        ref.read(favoritesKanjisProvider.notifier).removeItem(kanjiFromApi);
        Future.delayed(
          const Duration(
            seconds: 1,
          ),
          () {
            setStoringToFavoritesStatus(
                StoringToFavoritesStatus.successRemoved);
            setFavoritesStatusInKanjiDetailsData(!queryKanji);
          },
        );
      } catch (e) {
        logger.e(e);
        setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    }
  }

  void createPdfSheet(String strokeLink) async {
    final temporalPath = await downloadStrokeData(
      strokeLink,
      ref.read(authServiceProvider).userUuid ?? '',
    );

    File file = File(temporalPath);
    var svgRaw = file.readAsStringSync();
    final pdfFile = await PdfApi.pdfGenerator(svgRaw);
    await SaveAndOpenPdf.openPdf(pdfFile);
  }

  void initKanjiDetails(KanjiFromApi kanjiFromApi) {
    final isInFavorites = ref
        .read(favoritesKanjisProvider.notifier)
        .searchInFavorites(kanjiFromApi.kanjiCharacter);

    setInitValues(
      kanjiFromApi,
      kanjiFromApi.statusStorage,
      isInFavorites,
    );

    ref.read(customNavigationRailsDetailsProvider.notifier).setSelection(0);
    ref.read(videoStatusPlaying.notifier).setSpeed(1.0);
    ref.read(videoStatusPlaying.notifier).setIsPlaying(true);
    ref.read(examplesAudiosTrackListProvider).assetsAudioPlayer.stop();
    ref.read(examplesAudiosTrackListProvider.notifier).setIsPlaying(false);
    ref
        .read(examplesAudiosPlayingAudioProvider.notifier)
        .setInitList(kanjiFromApi);
  }
}

enum StoringToFavoritesStatus {
  noStarted('Not started'),
  processing('Processing'),
  successAdded('Added to favorites!'),
  successRemoved('Removed from favorites'),
  error('error in storing');

  const StoringToFavoritesStatus(this.message);
  final String message;
  @override
  String toString() => message;
}

final kanjiDetailsProvider =
    NotifierProvider<KanjiDetailsProvider, KanjiDetailsData?>(
        KanjiDetailsProvider.new);

class KanjiDetailsData {
  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;
  final bool favoriteStatus;
  final StoringToFavoritesStatus storingToFavoritesStatus;

  KanjiDetailsData({
    required this.kanjiFromApi,
    required this.statusStorage,
    required this.favoriteStatus,
    required this.storingToFavoritesStatus,
  });
}
