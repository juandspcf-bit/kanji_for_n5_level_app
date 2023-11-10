import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';

void deleteKanjiFromStorageComputeVersion(
  KanjiFromApi kanjiFromApi,
  WidgetRef ref,
  bool selection,
  BuildContext buildContext,
) async {
  try {
    final db = await kanjiFromApiDatabase;

    final listKanjiMapFromDb = await db.rawQuery(
        'SELECT * FROM kanji_FromApi WHERE kanjiCharacter = ? ',
        [kanjiFromApi.kanjiCharacter]);
    final listMapExamplesFromDb = await db.rawQuery(
        'SELECT * FROM examples WHERE kanjiCharacter = ? ',
        [kanjiFromApi.kanjiCharacter]);
    final listMapStrokesImagesLisnkFromDb = await db.rawQuery(
        'SELECT * FROM strokes WHERE kanjiCharacter = ? ',
        [kanjiFromApi.kanjiCharacter]);

    final parametersDelete = ParametersDelete(
        listKanjiMapFromDb: listKanjiMapFromDb,
        listMapExamplesFromDb: listMapExamplesFromDb,
        listMapStrokesImagesLisnkFromDb: listMapStrokesImagesLisnkFromDb);

    await compute(deleteKanjiFromApiComputeVersion, parametersDelete);

    await db.rawDelete('DELETE FROM kanji_FromApi WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await db.rawDelete('DELETE FROM examples WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await db.rawDelete('DELETE FROM strokes WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);

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
            updateStatusKanjiComputeVersion(
                StatusStorage.errorDeleting, true, kanjiFromApi));
      } else {
        ref.read(kanjiListProvider.notifier).updateKanji(
            updateStatusKanjiComputeVersion(
                StatusStorage.errorDeleting, true, kanjiFromApi));
      }
      _scaleDialogError(buildContext);
    }

    updateKanjiWithOnliVersionComputeVersion(kanjiFromApi, onSuccess, onError);

    logger.d('success');
  } catch (e) {
    if (buildContext.mounted) {
      _scaleDialogError(buildContext);
    }

    logger.e('error sotoring');
    logger.e(e.toString());
  }
}

class ParametersDelete {
  final List<Map<String, Object?>> listKanjiMapFromDb;
  final List<Map<String, Object?>> listMapExamplesFromDb;
  final List<Map<String, Object?>> listMapStrokesImagesLisnkFromDb;

  ParametersDelete({
    required this.listKanjiMapFromDb,
    required this.listMapExamplesFromDb,
    required this.listMapStrokesImagesLisnkFromDb,
  });
}

Future<void> deleteKanjiFromApiComputeVersion(
    ParametersDelete parametersDelete) async {
  if (parametersDelete.listKanjiMapFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiImageLinkFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listKanjiMapFromDb
          .map((e) => e['kanjiImageLink'] as String)
          .map((e) {
        final kanjiImageLinkFile = File(e);
        groupKanjiImageLinkFile.add(kanjiImageLinkFile.delete());
      });

      groupKanjiImageLinkFile.close();
      await groupKanjiImageLinkFile.future;

      FutureGroup<FileSystemEntity> groupKanjiVideoLinkFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listKanjiMapFromDb
          .map((e) => e['videoLink'] as String)
          .map((e) {
        final videoLinkFile = File(e);
        groupKanjiVideoLinkFile.add(videoLinkFile.delete());
      });

      groupKanjiVideoLinkFile.close();
      await groupKanjiVideoLinkFile.future;
    } catch (e) {
      e.toString();
    }
  }

  if (parametersDelete.listMapExamplesFromDb.isNotEmpty) {
    try {
      FutureGroup<int> groupKanjiExampleAudioLinksFile = FutureGroup<int>();

      parametersDelete.listMapExamplesFromDb.map((exampleFromDb) {
        return AudioExamples(
            opus: exampleFromDb['opus'] as String,
            aac: exampleFromDb['aac'] as String,
            ogg: exampleFromDb['ogg'] as String,
            mp3: exampleFromDb['mp3'] as String);
      }).map((e) async {
        groupKanjiExampleAudioLinksFile.add(Future(() async {
          final opusFile = File(e.opus);
          await opusFile.delete();
          final aacFile = File(e.aac);
          await aacFile.delete();
          final oggFile = File(e.ogg);
          await oggFile.delete();
          final mp3File = File(e.mp3);
          await mp3File.delete();
          return 1;
        }));
      });

      groupKanjiExampleAudioLinksFile.close();
      await groupKanjiExampleAudioLinksFile.future;
    } catch (e) {
      e.toString();
    }
  }

  if (parametersDelete.listMapStrokesImagesLisnkFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiStrokesLinksFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listMapStrokesImagesLisnkFromDb
          .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
          .map((e) {
        final strokeLinkFile = File(e);
        groupKanjiStrokesLinksFile.add(strokeLinkFile.delete());
      });

      groupKanjiStrokesLinksFile.close();
      await groupKanjiStrokesLinksFile.future;
    } catch (e) {
      e.toString();
    }
  }
}

void updateKanjiWithOnliVersionComputeVersion(KanjiFromApi kanjiFromApi,
    void Function(List<KanjiFromApi> data) onSucces, void Function() onError) {
  RequestApi.getKanjis([], [kanjiFromApi.kanjiCharacter], kanjiFromApi.section,
      onSucces, onError);
}

KanjiFromApi updateStatusKanjiComputeVersion(
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

Widget _dialogError(BuildContext buildContext) {
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
