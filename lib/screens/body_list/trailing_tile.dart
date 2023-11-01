import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/access_to_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class TrailingTile extends ConsumerWidget {
  const TrailingTile({
    super.key,
    required this.accessToKanjiItemsButtons,
    required this.kanjiFromApi,
    required this.setAccessToKanjiItemsButtons,
  });

  final bool accessToKanjiItemsButtons;
  final KanjiFromApi kanjiFromApi;
  final void Function(bool value) setAccessToKanjiItemsButtons;

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
      StatusStorage statusStorage, KanjiFromApi kanjiFromApi) {
    return KanjiFromApi(
        kanjiCharacter: kanjiFromApi.kanjiCharacter,
        englishMeaning: kanjiFromApi.englishMeaning,
        kanjiImageLink: kanjiFromApi.kanjiImageLink,
        katakanaMeaning: kanjiFromApi.katakanaMeaning,
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        videoLink: kanjiFromApi.videoLink,
        section: kanjiFromApi.section,
        statusStorage: statusStorage,
        example: kanjiFromApi.example,
        strokes: kanjiFromApi.strokes);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (!accessToKanjiItemsButtons) return;
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
                  updateStatusKanji(StatusStorage.onlyOnline, kanjiFromApi));
            } else {
              ref.read(kanjiListProvider.notifier).updateKanji(
                  updateStatusKanji(StatusStorage.onlyOnline, kanjiFromApi));
            }
          }).whenComplete(() {
            ref.read(accesToQuizProvider.notifier).giveAccesToQuiz();
            setAccessToKanjiItemsButtons(true);
          });
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          deleteKanjiFromApi(kanjiFromApi).then((value) {
            ref.read(statusStorageProvider.notifier).deleteItem(kanjiFromApi);
            RequestApi.getKanjis(
                [], [kanjiFromApi.kanjiCharacter], kanjiFromApi.section,
                (list) {
              if (selection) {
                ref.read(favoritesCachedProvider.notifier).updateKanji(list[0]);
              } else {
                ref.read(kanjiListProvider.notifier).updateKanji(list[0]);
              }
              ref.read(accesToQuizProvider.notifier).giveAccesToQuiz();
              setAccessToKanjiItemsButtons(true);
            }, () {
              if (selection) {
                ref.read(favoritesCachedProvider.notifier).updateKanji(
                    updateStatusKanji(StatusStorage.stored, kanjiFromApi));
              } else {
                ref.read(kanjiListProvider.notifier).updateKanji(
                    updateStatusKanji(StatusStorage.stored, kanjiFromApi));
              }
              ref.read(accesToQuizProvider.notifier).giveAccesToQuiz();
              setAccessToKanjiItemsButtons(true);
            });
          }).catchError((onError) {
            if (selection) {
              ref.read(favoritesCachedProvider.notifier).updateKanji(
                  updateStatusKanji(StatusStorage.stored, kanjiFromApi));
            } else {
              ref.read(kanjiListProvider.notifier).updateKanji(
                  updateStatusKanji(StatusStorage.stored, kanjiFromApi));
            }

            ref.read(accesToQuizProvider.notifier).giveAccesToQuiz();
            setAccessToKanjiItemsButtons(true);
          });
        }

        if (selection) {
          ref.read(favoritesCachedProvider.notifier).updateKanji(
                updateStatusKanji(StatusStorage.dowloading, kanjiFromApi),
              );
        } else {
          ref.read(accesToQuizProvider.notifier).denyAccesToQuiz();
          ref.read(kanjiListProvider.notifier).updateKanji(
                updateStatusKanji(StatusStorage.dowloading, kanjiFromApi),
              );
        }

        setAccessToKanjiItemsButtons(false);
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi),
      ),
    );
  }
}
