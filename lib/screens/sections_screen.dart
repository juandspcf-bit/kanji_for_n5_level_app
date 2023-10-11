import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secciones"),
      ),
      body: Center(
        child: Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            "Seccion 1",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontFamily: GoogleFonts.alkatra().fontFamily),
          ),
        ),
      ),
    );
  }
}
