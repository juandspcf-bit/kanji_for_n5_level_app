import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';

class TrailingTile extends ConsumerWidget {
  const TrailingTile({
    super.key,
    required this.kanjiFromApi,
    required this.insertKanji,
    required this.deleteKanji,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(KanjiFromApi kanjiFromApi) insertKanji;
  final void Function(KanjiFromApi kanjiFromApi) deleteKanji;

  Widget _dialogError(BuildContext buildContext) {
    return AlertDialog(
      title: const Text(
          'The max number of parallel downloads is three, please wait until they are finished'),
      content: const Icon(
        Icons.block,
        color: Colors.amberAccent,
        size: 70,
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

  void _scaleDialogError(BuildContext buildContext) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialogError(buildContext),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget selectWidgetStatus(KanjiFromApi kanjiFromApi, BuildContext context) {
    if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
      return Icon(
        Icons.download_for_offline,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
      return Icon(
        Icons.storage,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    } else if (kanjiFromApi.statusStorage == StatusStorage.proccessingStoring ||
        kanjiFromApi.statusStorage == StatusStorage.proccessingDeleting) {
      return const CircularProgressIndicator();
    } else {
      return Icon(
        Icons.question_mark_rounded,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 50,
      );
    }
  }

  void showSnackBarQuizz(BuildContext context, String message, int duration) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: duration),
          content: Text(message),
        ),
      );
    }
  }

  int countActiveDownloads(List<KanjiFromApi> kanjiList) {
    return kanjiList
        .where(
            (kanji) => kanji.statusStorage == StatusStorage.proccessingStoring)
        .toList()
        .length;
  }

  bool isMoreOfTheAllowedDownloads(
      BuildContext context, List<KanjiFromApi> kanjiList) {
    int countActivesDownloads = countActiveDownloads(kanjiList);
    return countActivesDownloads >= 3;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: /* isMoreOfTheAllowedDownloads(
              context, ref.read(kanjiListProvider).$1)
          ? null
          :  */
          () {
        if (!kanjiFromApi.accessToKanjiItemsButtons) return;

        final resultStatus = ref.read(statusConnectionProvider);
        if (ConnectivityResult.none == resultStatus) {
          showSnackBarQuizz(
              context, 'you shoul be connected to performn this acction', 3);
          return;
        }

        if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
          insertKanji(kanjiFromApi);
        } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
          deleteKanji(kanjiFromApi);
        }
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: selectWidgetStatus(kanjiFromApi, context),
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
      title: const Text(
          'An issue happened when deleting this item, please go back to the section list and access the content again to see the updated content.'),
      content: const Icon(
        Icons.error_rounded,
        color: Colors.amberAccent,
        size: 70,
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
        //TODO handle error connection online

        if (selection) {
          ref.read(favoritesCachedProvider.notifier).updateKanji(
              updateStatusKanji(
                  StatusStorage.errorDeleting, true, kanjiFromApi));
        } else {
          ref.read(kanjiListProvider.notifier).updateKanji(updateStatusKanji(
              StatusStorage.errorDeleting, true, kanjiFromApi));
        }
        _scaleDialogError();
      }

      updateKanjiWithOnliVersion(
          kanjiFromApi, selection, ref, onSuccess, onError);
    }).onError((error, stackTrace) {
      //TODO handle error connection database and others

      if (selection) {
        ref.read(favoritesCachedProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.errorDeleting, true, kanjiFromApi));
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.errorDeleting, true, kanjiFromApi));
      }
    });
  }

  void insertKanjiToStorage() {
    insertKanjiFromApi(kanjiFromApi).then((kanjiFromApiStored) {
      ref.read(statusStorageProvider.notifier).addItem(kanjiFromApiStored);

      if (selection) {
        ref
            .read(favoritesCachedProvider.notifier)
            .updateKanji(kanjiFromApiStored);
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(kanjiFromApiStored);
      }
    }).catchError((onError) {
      logger.d('the error is $onError');
      if (selection) {
        ref.read(favoritesCachedProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.onlyOnline, true, kanjiFromApi));
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(StatusStorage.onlyOnline, true, kanjiFromApi));
      }
    });
  }

  void updateKanjiItemStatusToProcessingStatus(StatusStorage statusStorage) {
    if (selection) {
      ref.read(favoritesCachedProvider.notifier).updateKanji(
            updateStatusKanji(statusStorage, false, kanjiFromApi),
          );
    } else {
      ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanji(statusStorage, false, kanjiFromApi),
          );
    }
  }
}
