import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class QuizDetailsScreen extends ConsumerStatefulWidget {
  const QuizDetailsScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends ConsumerState<QuizDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
