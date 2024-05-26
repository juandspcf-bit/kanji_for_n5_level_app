import 'package:flutter/material.dart';

class KanjiCharacterTitle extends StatelessWidget {
  const KanjiCharacterTitle({
    super.key,
    required this.kanjisCharacters,
    required this.index,
  });

  final List<String> kanjisCharacters;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Text(
        kanjisCharacters[index],
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
