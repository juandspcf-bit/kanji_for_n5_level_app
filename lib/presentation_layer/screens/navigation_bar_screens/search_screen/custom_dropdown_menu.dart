import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/custom_dropdown_menu_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/list_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/title_grade_provider.dart';

class CustomDropdownMenu extends ConsumerWidget {
  const CustomDropdownMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownMenuState = ref.watch(customDropdownMenuStateProvider);
    return Column(
      children: [
        DropdownMenu<GradeKanji>(
          controller: dropdownMenuState.controller,
          requestFocusOnTap: false,
          label: const Text('Grade'),
          onSelected: (GradeKanji? grade) {
            logger.d("selected grade $grade");
            if (grade != null) {
              ref
                  .read(customDropdownMenuStateProvider.notifier)
                  .setGrade(grade);
            }
          },
          dropdownMenuEntries: GradeKanji.values
              .map<DropdownMenuEntry<GradeKanji>>((GradeKanji grade) {
            return DropdownMenuEntry<GradeKanji>(
              value: grade,
              label: "Grade ${grade.grade}",
              style: MenuItemButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize:
                MediaQuery.orientationOf(context) == Orientation.portrait
                    ? const Size.fromHeight(50)
                    : const Size(300, 50),
          ),
          onPressed: () {
            final grade = dropdownMenuState.grade;

            if (ref.read(listKanjisStateProvider).isLoading) return;

            if (grade != null) {
              ref
                  .read(listKanjisStateProvider.notifier)
                  .searchKanjisByGrade(grade.grade);
              ref.read(titleGradeProvider.notifier).setTitle(grade.grade);
            } else {
              ref.read(toastServiceProvider).showMessage(
                    context,
                    "select a grade",
                    Icons.error,
                    const Duration(seconds: 5),
                    "",
                    null,
                  );
            }
          },
          label: const Text("search"),
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}
