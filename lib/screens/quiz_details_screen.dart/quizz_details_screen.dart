import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class QuizDetailsScreen extends ConsumerStatefulWidget {
  const QuizDetailsScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends ConsumerState<QuizDetailsScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    final stateQuiz = ref.watch(quizDetailsProvider);
    return Scaffold(
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Question 1 of 5'),
            ],
          ),
          Container(
            child: IconButton(
              color: Theme.of(context).colorScheme.onPrimary,
              splashColor: Colors.deepOrange,
              onPressed: () async {
                final assetsAudioPlayer = AssetsAudioPlayer();

                try {
                  if (widget.kanjiFromApi.statusStorage ==
                      StatusStorage.onlyOnline) {
                    await assetsAudioPlayer.open(
                      Audio.network(stateQuiz.audioQuestion),
                    );
                  } else if (widget.kanjiFromApi.statusStorage ==
                      StatusStorage.stored) {
                    await assetsAudioPlayer.open(
                      Audio.file(stateQuiz.audioQuestion),
                    );
                  }
                } catch (t) {
                  //mp3 unreachable
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
          ),
          RadioListTile(
              value: 1,
              title: Text(stateQuiz.answer1.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer1.englishMeaning),
              groupValue: 1,
              onChanged: ((value) {})),
          RadioListTile(
              value: 2,
              title: Text(stateQuiz.answer2.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer2.englishMeaning),
              groupValue: 1,
              onChanged: ((value) {})),
          RadioListTile(
              value: 2,
              title: Text(stateQuiz.answer3.hiraganaMeaning),
              subtitle: Text(stateQuiz.answer3.englishMeaning),
              groupValue: 1,
              onChanged: ((value) {})),
        ],
      ),
    );
  }
}
