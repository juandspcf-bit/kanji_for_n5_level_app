import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class TrailingTile extends ConsumerWidget {
  const TrailingTile({
    super.key,
    required this.kanjiFromApi,
    //required this.setAccessToKanjiItemsButtons,
  });

  final KanjiFromApi kanjiFromApi;
  //final void Function(bool value) setAccessToKanjiItemsButtons;

  Widget selectWidgetStatus(KanjiFromApi kanjiFromApi) {
    if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
      return const Icon(
        Icons.download_for_offline,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
      return const Icon(
        Icons.storage,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.dowloading) {
      return const CircularProgressIndicator();
    }

    return const Icon(
      Icons.question_mark,
      size: 50,
    );
  }

  KanjiFromApi updateStatusKanji(
    StatusStorage statusStorage,
    bool accessToKanjiItemsButtons,
    KanjiFromApi kanjiFromApi,
  ) {
    return KanjiFromApi(
        kanjiCharacter: kanjiFromApi.kanjiCharacter,
        englishMeaning: kanjiFromApi.englishMeaning,
        kanjiImageLink: kanjiFromApi.kanjiImageLink,
        katakanaMeaning: kanjiFromApi.katakanaMeaning,
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        videoLink: kanjiFromApi.videoLink,
        section: kanjiFromApi.section,
        statusStorage: statusStorage,
        accessToKanjiItemsButtons: accessToKanjiItemsButtons,
        example: kanjiFromApi.example,
        strokes: kanjiFromApi.strokes);
  }

  void updateKanjiWithOnliVersion(
      KanjiFromApi kanjiFromApi,
      bool selection,
      WidgetRef ref,
      void Function(List<KanjiFromApi> data) onSucces,
      void Function() onError) {
    RequestApi.getKanjis([], [kanjiFromApi.kanjiCharacter],
        kanjiFromApi.section, onSucces, onError);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (!kanjiFromApi.accessToKanjiItemsButtons) return;
        final selection =
            ref.read(favoriteScreenSelectionProvider.notifier).getSelection();

        if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
          insertKanjiFromApi(kanjiFromApi).then((kanjiFromApiStored) {
            //print(' my stored kanji is $kanjiFromApiStored');
            ref
                .read(statusStorageProvider.notifier)
                .addItem(kanjiFromApiStored);

            if (selection) {
              ref
                  .read(favoritesCachedProvider.notifier)
                  .updateKanji(kanjiFromApiStored);
            } else {
              ref
                  .read(kanjiListProvider.notifier)
                  .updateKanji(kanjiFromApiStored);
            }
          }).catchError((onError) {
            if (selection) {
              ref.read(favoritesCachedProvider.notifier).updateKanji(
                  updateStatusKanji(
                      StatusStorage.onlyOnline, true, kanjiFromApi));
            } else {
              ref.read(kanjiListProvider.notifier).updateKanji(
                  updateStatusKanji(
                      StatusStorage.onlyOnline, true, kanjiFromApi));
            }
          });
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          deleteKanjiFromApi(kanjiFromApi).then((deleteStatus) {
            ref.read(statusStorageProvider.notifier).deleteItem(kanjiFromApi);

            onSuccess(List<KanjiFromApi> list) {
              if (selection) {
                ref.read(favoritesCachedProvider.notifier).updateKanji(list[0]);
              } else {
                ref.read(kanjiListProvider.notifier).updateKanji(list[0]);
              }
            }

            onError() {
              if (selection) {
                ref.read(favoritesCachedProvider.notifier).updateKanji(
                    updateStatusKanji(
                        StatusStorage.stored, true, kanjiFromApi));
              } else {
                ref.read(kanjiListProvider.notifier).updateKanji(
                    updateStatusKanji(
                        StatusStorage.stored, true, kanjiFromApi));
              }
            }

            updateKanjiWithOnliVersion(
                kanjiFromApi, selection, ref, onSuccess, onError);
          }).catchError((onError) {
            if (selection) {
              ref.read(favoritesCachedProvider.notifier).updateKanji(
                  updateStatusKanji(StatusStorage.stored, true, kanjiFromApi));
            } else {
              ref.read(kanjiListProvider.notifier).updateKanji(
                  updateStatusKanji(StatusStorage.stored, true, kanjiFromApi));
            }
          });
        }

        if (selection) {
          ref.read(favoritesCachedProvider.notifier).updateKanji(
                updateStatusKanji(
                    StatusStorage.dowloading, false, kanjiFromApi),
              );
        } else {
          ref.read(kanjiListProvider.notifier).updateKanji(
                updateStatusKanji(
                    StatusStorage.dowloading, false, kanjiFromApi),
              );
        }

        //setAccessToKanjiItemsButtons(false);
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi),
      ),
    );
  }
}
