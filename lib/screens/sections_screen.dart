import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
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
    return InkWell(
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
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: 128,
        height: 128,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
/*             gradient:
                const LinearGradient(colors: [
              Color.fromARGB(
                  255, 66, 53, 245), //Color.fromARGB(255, 245, 95, 53),
              Color.fromARGB(255, 51, 130, 142),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight), */
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white38)),
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
    );
  }
}
