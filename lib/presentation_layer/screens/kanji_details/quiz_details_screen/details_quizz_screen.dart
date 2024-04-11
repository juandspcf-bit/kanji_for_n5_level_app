import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class DetailsQuizScreen extends ConsumerWidget {
  const DetailsQuizScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test your knowledge',
        ),
      ),
      body: WelcomeScreen(
        kanjiFromApi: kanjiFromApi,
      ),
    );
  }
}
