import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = getScreenSizeWidth(context);
    int crossAxisCount;
    switch (sizeScreen) {
      case ScreenSizeWidth.extraLarge:
        crossAxisCount = 4;
      case ScreenSizeWidth.large:
        crossAxisCount = 3;
      case _:
        crossAxisCount = 2;
    }

    logger.d(sizeScreen);
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 40,
      ),
      children: [
        for (final sectionData in listSections)
          Section(sectionData: sectionData)
      ],
    );
  }
}

class Section extends ConsumerWidget {
  const Section({
    super.key,
    required this.sectionData,
  });

  final SectionModel sectionData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.grey[800]!),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Colors.grey[900]!,
            Colors.grey[800]!,
          ],
        ),
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: () {
            ref.read(kanjiListProvider.notifier).fetchKanjis(
                  kanjisCharacters: sectionData.kanjisCharacters,
                  sectionNumber: sectionData.sectionNumber,
                );
            ref
                .read(sectionProvider.notifier)
                .setSection(sectionData.sectionNumber);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return const KanjiForSectionScreen();
                },
              ),
            );
          },
          splashColor: Colors.black12,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  sectionData.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontFamily: GoogleFonts.roboto().fontFamily),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Seccion ${sectionData.sectionNumber}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontFamily: GoogleFonts.roboto().fontFamily),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
