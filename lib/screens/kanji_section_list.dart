import 'package:flutter/material.dart';

class KanjiSecctionList extends StatelessWidget {
  const KanjiSecctionList({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
