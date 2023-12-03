import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quiz_details_score.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/welcome_quiz_details_screen.dart';

class QuizDetailsScreen extends ConsumerStatefulWidget {
  const QuizDetailsScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends ConsumerState<QuizDetailsScreen> {
  Widget _selectScreen(ScreensQuizDetail screenNumber) {
    if (screenNumber == ScreensQuizDetail.welcome) {
      return const WelcomeQuizDetailsScreen();
    } else if (screenNumber == ScreensQuizDetail.quizSelections) {
      return QuestionScreen(kanjiFromApi: widget.kanjiFromApi);
    } else if (screenNumber == ScreensQuizDetail.scoreSelections) {
      return const QuizDetailsScore();
    } else if (screenNumber == ScreensQuizDetail.quizFlashCard) {
      return FlassCardScreen(kanjiFromApi: widget.kanjiFromApi);
    } else {
      return const Center(
        child: Text('Error'),
      );
    }
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test your knowledge',
        ),
      ),
      body: _selectScreen(screenNumber.screensQuizDetail),
    );
  }
}
