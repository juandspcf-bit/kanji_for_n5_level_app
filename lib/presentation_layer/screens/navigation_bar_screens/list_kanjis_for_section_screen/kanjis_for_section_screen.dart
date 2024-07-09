import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_kanjis_for_section_screen/connection_status_icon.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_kanjis_for_section_screen/quiz_icon_kanji_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
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
    final kanjiListData = ref.watch(kanjiListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sections("section_${kanjiListData.section}")),
        actions: const [
          ConnectionStatusIcon(),
          QuizIconKanjiList(),
        ],
      ),
      body: BodyKanjisList(
        kanjisFromApi: kanjiListData.kanjiList,
        statusResponse: kanjiListData.status,
      ),
    );
  }
}
