import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeOnBoardScreen extends ConsumerWidget {
  const WelcomeOnBoardScreen({super.key});

  final welcomeMessage =
      'Welcome to kanji for N5, this is a walk through , introducing the features of the app.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: Image.asset(
            'assets/images/learning.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                welcomeMessage,
                style: Theme.of(context).textTheme.titleLarge,
                softWrap: false,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size.fromHeight(40),
            ),
          ),
          child: const Text('Start the quiz'),
        )
      ],
    );
  }
}

class SectionOnBoardScreen extends ConsumerWidget {
  const SectionOnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'You can access a list of kanjis  grouped in different topics in the sections screen.',
                style: Theme.of(context).textTheme.titleLarge,
                softWrap: false,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 250,
          child: Image.asset(
            'assets/images/section.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 250,
          child: Image.asset(
            'assets/images/section_nav.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size.fromHeight(40),
            ),
          ),
          child: const Text('Start the quiz'),
        )
      ],
    );
  }
}
