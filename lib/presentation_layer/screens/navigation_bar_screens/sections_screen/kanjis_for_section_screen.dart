import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/cache_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanji_sections_quiz_animation.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

class KanjiForSectionScreen extends ConsumerWidget
    with MyDialogs, StatusDBStoringDialogs {
  const KanjiForSectionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(errorDatabaseStatusProvider)) {
      errorDialog(
        context,
        () {
          ref
              .read(errorDatabaseStatusProvider.notifier)
              .setDeletingError(false);
        },
        'An issue happened when deleting this item, please go back to the section'
        ' list and access the content again to see the updated content.',
      );
    }

    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
    var kanjiListData = ref.watch(kanjiListProvider);

/*     if (connectivityData == ConnectivityResult.none &&
        !ref
            .read(cacheKanjiListProvider.notifier)
            .isInCache(kanjiListData.section)) {
      kanjiListData = ref
          .read(kanjiListProvider.notifier)
          .getOfflineKanjiList(kanjiListData);
    } */

    ref.listen<KanjiListData>(kanjiListProvider, (previuos, current) {
      if (current.errorDownload.status) {
        ScaffoldMessenger.of(context).clearSnackBars();
        var snackBar = SnackBar(
          content: Text(
              'error downloading kanji ${current.errorDownload.kanjiCharacter}'),
          duration: const Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        ref.read(kanjiListProvider.notifier).setErrorDownload(
              ErrorDownload(
                kanjiCharacter: '',
                status: false,
              ),
            );
      }

      if (current.errorDeleting.status) {
        ScaffoldMessenger.of(context).clearSnackBars();
        var snackBar = SnackBar(
          content: Text(
              'error removing stored kanji ${current.errorDeleting.kanjiCharacter}'),
          duration: const Duration(seconds: 3),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        ref.read(kanjiListProvider.notifier).setErrorDelete(
              ErrorDeleting(
                kanjiCharacter: '',
                status: false,
              ),
            );
      }
    });

    final isAnyProcessingDataFunc =
        ref.read(kanjiListProvider.notifier).isAnyProcessingData;

    final accesToQuiz = !isAnyProcessingDataFunc() &&
        !(connectivityData == ConnectivityResult.none);

    return Scaffold(
      appBar: AppBar(
        title: Text(listSections[kanjiListData.section - 1].title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: connectivityData == ConnectivityResult.none
                ? const Icon(Icons.cloud_off)
                : const Icon(Icons.cloud_done_rounded),
          ),
          if (kanjiListData.status == 1 && accesToQuiz)
            const AnimatedOpacityIcon(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: KanjiSectionsQuizAnimated(
                  closedChild: Icon(Icons.quiz),
                ),
              ),
            ),
        ],
      ),
      body: BodyKanjisList(
        kanjisFromApi: kanjiListData.kanjiList,
        statusResponse: kanjiListData.status,
        connectivityData: connectivityData,
        mainScreenData: mainScreenData,
      ),
    );
  }
}

class AnimatedOpacityIcon extends ConsumerStatefulWidget {
  const AnimatedOpacityIcon({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AnimatedOpacityIcon> createState() => _AnimationFadeState();
}

class _AnimationFadeState extends ConsumerState<AnimatedOpacityIcon> {
  double opacityLevel = 0.0;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 100), () {
      if (context.mounted) {
        setState(() {
          opacityLevel = 1.0;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: accelerateEasing,
      opacity: opacityLevel,
      duration: const Duration(milliseconds: 600),
      child: widget.child,
    );
  }
}
