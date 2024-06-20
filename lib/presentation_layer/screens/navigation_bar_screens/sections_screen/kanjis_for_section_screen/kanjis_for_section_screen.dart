import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/refresh_body/error_fetching_kanjis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/refresh_body/refresh_body_lis.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/shimmer_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen/connection_status_icon.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen/quiz_icon_kanji_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KanjiForSectionScreen extends ConsumerWidget
    with MyDialogs, StatusDBStoringDialogs {
  const KanjiForSectionScreen({
    super.key,
    required this.kanjiCharacters,
    required this.sectionNumber,
  });

  final List<String> kanjiCharacters;
  final int sectionNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    final kanjiListData = ref.watch(kanjiListProvider(
        kanjisCharacters: kanjiCharacters, sectionNumber: sectionNumber));

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!
              .sections("section_${sectionNumber}")),
          actions: const [
            ConnectionStatusIcon(),
            //QuizIconKanjiList(),
          ],
        ),
        body: kanjiListData.when(
          data: (data) {
            return RefreshBodyList(
              statusResponse: 1,
              kanjisFromApi: data,
              mainScreenData: mainScreenData,
            );
          },
          error: (_, __) {
            return ErrorFetchingKanjisScreen(mainScreenData: mainScreenData);
          },
          loading: () => SafeArea(
            child: ShimmerList(
              selection: mainScreenData.selection,
            ),
          ),
        ));
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
      curve: Easing.standardAccelerate,
      opacity: opacityLevel,
      duration: const Duration(milliseconds: 600),
      child: widget.child,
    );
  }
}
