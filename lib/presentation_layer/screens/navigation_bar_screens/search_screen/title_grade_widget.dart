import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/title_grade_provider.dart';

class TitleGradeWidget extends ConsumerWidget {
  const TitleGradeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleState = ref.watch(
        titleGradeProvider(initText: context.l10n.initMessageSearchGrade));
    return Text(
      titleState,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
