import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen/kanjis_for_section_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    int crossAxisCount;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          crossAxisCount = 4;
        }
      case (_, ScreenSizeWidth.extraLarge):
        crossAxisCount = 4;
      case (_, ScreenSizeWidth.large):
        crossAxisCount = 3;
      case (_, _):
        crossAxisCount = 2;
    }

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
        border: Border.all(color: Colors.white10),
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.5,
          image: AssetImage(sectionData.imagePath),
        ),
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: () {
            logger.d("fetching");
            ref
                .read(kanjiListProvider.notifier)
                .clearKanjiList(sectionData.sectionNumber);

            ref.read(kanjiListProvider.notifier).fetchKanjis(
                  kanjisCharacters: sectionData.kanjisCharacters,
                  sectionNumber: sectionData.sectionNumber,
                );
            ref
                .read(sectionProvider.notifier)
                .setSection(sectionData.sectionNumber);

            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                reverseTransitionDuration: const Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const KanjiForSectionScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(
                      animation.drive(
                        CurveTween(
                          curve: Curves.easeInOutBack,
                        ),
                      ),
                    ),
                    child: child,
                  );
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
                  context.l10n.sections("section_${sectionData.sectionNumber}"),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: GoogleFonts.roboto().fontFamily),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${context.l10n.ordinal_numbers((sectionData.sectionNumber).toString())}"
                  " ${context.l10n.section}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
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
