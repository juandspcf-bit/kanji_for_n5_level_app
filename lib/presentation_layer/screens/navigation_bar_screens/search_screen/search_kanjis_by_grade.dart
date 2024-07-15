import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_kanjis_by_grade_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_kanjis_by_grade_portrait.dart';

class SearchKanjisByGrade extends ConsumerWidget {
  const SearchKanjisByGrade({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait
        ? const SearchKanjisByGradePortrait()
        : const SearchKanjisByGradeLandscape();
  }
}
