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
                style: Theme.of(context).textTheme.titleMedium,
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
                style: Theme.of(context).textTheme.titleMedium,
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 380,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            image: const DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage('assets/images/section.png'),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ListOnBoardScreen extends ConsumerWidget {
  const ListOnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Click on any kanji from the list to see more details',
                style: Theme.of(context).textTheme.titleMedium,
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 380,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            image: const DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/images/list.png')),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class DetailsOnBoardScreen extends ConsumerWidget {
  const DetailsOnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'The details about the kanji includes its strokes, meaning and audio examples',
                    style: Theme.of(context).textTheme.titleMedium,
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 220,
              width: MediaQuery.sizeOf(context).width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                image: const DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/list_details_1.png')),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 220,
              width: MediaQuery.sizeOf(context).width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                image: const DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/list_details_3.png')),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizOnBoardScreen extends ConsumerWidget {
  const QuizOnBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'You can test your learning by doing different quizzes around the app ',
                    style: Theme.of(context).textTheme.titleMedium,
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 250,
              width: MediaQuery.sizeOf(context).width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                image: const DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/question.png')),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FinalBoardScreen extends ConsumerWidget {
  const FinalBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Enjoy your studying!',
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 400,
              //width: MediaQuery.sizeOf(context).width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/kimono.jpg')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
