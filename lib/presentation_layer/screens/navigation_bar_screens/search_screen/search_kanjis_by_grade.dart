import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/custom_dropdown_menu.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/list_kanjis_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/title_grade_widget.dart';

class SearchKanjisByGrade extends ConsumerStatefulWidget {
  const SearchKanjisByGrade({super.key});

  @override
  ConsumerState<SearchKanjisByGrade> createState() =>
      _SearchKanjisByGradeState();
}

class _SearchKanjisByGradeState extends ConsumerState<SearchKanjisByGrade> {
  final TextEditingController gradeController = TextEditingController();

  int grade = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              CustomDropdownMenu(),
              SizedBox(
                height: 20,
              ),
              TitleGradeWidget(),
              SizedBox(
                height: 20,
              ),
              Expanded(child: ListKanjisWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
