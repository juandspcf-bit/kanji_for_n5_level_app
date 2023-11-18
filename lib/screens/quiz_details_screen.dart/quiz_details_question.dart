import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class QuestionScreen extends ConsumerWidget {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final KanjiFromApi kanjiFromApi;

  QuestionScreen({super.key, required this.kanjiFromApi});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateQuiz = ref.watch(quizDetailsProvider);
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 0,
        right: 30,
        left: 30,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question ${stateQuiz.indexQuestion + 1} of ${kanjiFromApi.example.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(100)),
            child: IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              splashColor: Colors.deepOrange,
              onPressed: () async {
                final assetsAudioPlayer = AssetsAudioPlayer();

                try {
                  if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
                    await assetsAudioPlayer.open(
                      Audio.network(stateQuiz.audioQuestion),
                    );
                  } else if (kanjiFromApi.statusStorage ==
                      StatusStorage.stored) {
                    await assetsAudioPlayer.open(
                      Audio.file(stateQuiz.audioQuestion),
                    );
                  }
                } catch (t) {
                  //mp3 unreachable
                }
              },
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 80,
              ),
            ),
          ),
          RadioListTile(
              value: 0,
              title: Text(stateQuiz.answer1.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer1.englishMeaning),
              groupValue: stateQuiz.selectedAnswer,
              onChanged: ((value) {
                ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
              })),
          RadioListTile(
              value: 1,
              title: Text(stateQuiz.answer2.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer2.englishMeaning),
              groupValue: stateQuiz.selectedAnswer,
              onChanged: ((value) {
                ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
              })),
          RadioListTile(
              value: 2,
              title: Text(stateQuiz.answer3.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer3.englishMeaning),
              groupValue: stateQuiz.selectedAnswer,
              onChanged: ((value) {
                ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
              })),
          ElevatedButton.icon(
            onPressed: () {
              if (ref
                  .read(quizDetailsProvider.notifier)
                  .isQuizDataLenghtReached()) {
                ref.read(quizDetailsScoreProvider.notifier).setAnswers();
                ref.read(selectQuizDetailsProvider.notifier).setScreen(1);
                return;
              }

              ref.read(quizDetailsProvider.notifier).setQuizState(ref
                      .read(quizDetailsProvider.notifier)
                      .getQuizStateCurrentIndex() +
                  1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              textStyle: Theme.of(context).textTheme.bodyLarge,
              minimumSize: Size.fromHeight(
                  (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 30),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
