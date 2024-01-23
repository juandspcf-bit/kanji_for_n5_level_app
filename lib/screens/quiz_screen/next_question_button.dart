import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quiz_kanji_list_provider.dart';

class NextQuestionButton extends ConsumerWidget {
  const NextQuestionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        onPressed: () {
          ref.read(quizDataValuesProvider.notifier).onNext();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
        ),
        icon: const Icon(Icons.arrow_circle_right),
        label: const Text('Next'),
      ),
    );
  }
}
