import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgNetwork extends StatelessWidget {
  const SvgNetwork({
    super.key,
    required this.image,
    required this.kanjiCharacter,
  });

  final String image;
  final String kanjiCharacter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      image,
      semanticsLabel: kanjiCharacter,
      placeholderBuilder: (BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        color: Colors.transparent,
        child: const CircularProgressIndicator(
          backgroundColor: Color.fromARGB(179, 5, 16, 51),
        ),
      ),
    );
  }
}
