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
    } else if (kanjiFromApi.statusStorage == StatusStorage.proccessing) {
      return const CircularProgressIndicator();
    }

    return const Icon(
      Icons.question_mark,
      size: 50,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        if (!kanjiFromApi.accessToKanjiItemsButtons) return;
        final selection =
            ref.read(favoriteScreenSelectionProvider.notifier).getSelection();

        final kanjiItemProcessingHelper =
            KanjiItemProcessingHelper(kanjiFromApi, selection, ref, context);

        if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
          kanjiItemProcessingHelper.insertKanjiToStorage();
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          kanjiItemProcessingHelper.deleteKanjFromStorage();
        }

        kanjiItemProcessingHelper.updateKanjiItemStatusToProcessingStatus();
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi),
      ),
    );
  }
}

class KanjiItemProcessingHelper {
  const KanjiItemProcessingHelper(
      this.kanjiFromApi, this.selection, this.ref, this.buildContext);

  final KanjiFromApi kanjiFromApi;
  final bool selection;
  final WidgetRef ref;
  final BuildContext buildContext;

  Widget _dialogError() {
    return AlertDialog(
      title: const Text("Error during storing data!!"),
      content: const Icon(
        Icons.error_rounded,
        color: Colors.amberAccent,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(buildContext).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialogError() {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialogError(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
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

  void deleteKanjFromStorage() {
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
        //TODO handle error
        if (selection) {
          ref.read(favoritesCachedProvider.notifier).updateKanji(
              updateStatusKanji(StatusStorage.stored, true, kanjiFromApi));
        } else {
          ref.read(kanjiListProvider.notifier).updateKanji(
              updateStatusKanji(StatusStorage.stored, true, kanjiFromApi));
        }
      }

      updateKanjiWithOnliVersion(
          kanjiFromApi, selection, ref, onSuccess, onError);
    });
  }

  void insertKanjiToStorage() {
    insertKanjiFromApi(kanjiFromApi).then((kanjiFromApiStored) {
      //print(' my stored kanji is $kanjiFromApiStored');
      ref.read(statusStorageProvider.notifier).addItem(kanjiFromApiStored);

      if (selection) {
        ref
            .read(favoritesCachedProvider.notifier)
            .updateKanji(kanjiFromApiStored);
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(kanjiFromApiStored);
      }
    }).catchError((onError) {
      if (selection) {
        ref.read(favoritesCachedProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.onlyOnline, true, kanjiFromApi));
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.onlyOnline, true, kanjiFromApi));
      }
    });
  }

  void updateKanjiItemStatusToProcessingStatus() {
    if (selection) {
      ref.read(favoritesCachedProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.proccessing, false, kanjiFromApi),
          );
    } else {
      ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.proccessing, false, kanjiFromApi),
          );
    }
  }
}
