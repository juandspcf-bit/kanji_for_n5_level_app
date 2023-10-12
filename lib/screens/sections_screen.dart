import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

const temporalAvatar =
    "https://firebasestorage.googleapis.com/v0/b/kanji-for-n5.appspot.com/o/unnamed.jpg?alt=media&token=38275fec-42f3-4d95-b1fd-785e82d4086f&_gl=1*19p8v1f*_ga*MjAyNTg0OTcyOS4xNjk2NDEwODIz*_ga_CW55HF8NVT*MTY5NzEwMTY3NC45LjEuMTY5NzEwMzExMy4zMy4wLjA.";

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Juan"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                imageUrl: temporalAvatar,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
      body: GridView(
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
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.sectionData,
  });

  final SectionModel sectionData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: 128,
        height: 128,
        decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.secondaryContainer,
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white38)),
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
    );
  }
}
