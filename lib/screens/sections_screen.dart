import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = getScreenSize(context);
    int crossAxisCount;
    switch (sizeScreen) {
      case ScreenSize.extraLarge:
        crossAxisCount = 4;
      case ScreenSize.large:
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

class Section extends ConsumerStatefulWidget {
  const Section({
    super.key,
    required this.sectionData,
  });

  final SectionModel sectionData;

  @override
  ConsumerState<Section> createState() => _SectionState();
}

class _SectionState extends ConsumerState<Section> {
  void showSnackBarQuizz(String message, int duration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          onTap: () {
            ref.read(kanjiListProvider.notifier).setKanjiListFromRepositories(
                widget.sectionData.kanjis, widget.sectionData.sectionNumber);

            Connectivity().checkConnectivity().then((result) {
              if (result == ConnectivityResult.none) {
                showSnackBarQuizz('no internet connection', 5);
              }
            });

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return const KanjiSectionList();
                },
              ),
            );
          },
          splashColor: Colors.black38,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.sectionData.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontFamily: GoogleFonts.roboto().fontFamily),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Seccion ${widget.sectionData.sectionNumber}",
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
