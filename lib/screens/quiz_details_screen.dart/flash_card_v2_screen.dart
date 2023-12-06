import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/big_play_button.dart';

class FlassCardV2Screen extends ConsumerStatefulWidget {
  const FlassCardV2Screen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<FlassCardV2Screen> createState() => _FlassCardScreenState();
}

class _FlassCardScreenState extends ConsumerState<FlassCardV2Screen> {
  final PageController controller = PageController();
  bool _showFrontSide = false;

  Widget __buildLayout(
      {required Key key,
      required String faceName,
      required Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(faceName.substring(0, 1),
            style: const TextStyle(fontSize: 80.0)),
      ),
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: const ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "F",
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: const ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "R",
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          origin: const Offset(100, 0),
          transform: Matrix4.rotationY(value),
          child: widget,
        );
      },
    );
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: () => setState(() => _showFrontSide = !_showFrontSide),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: __transitionBuilder,
        child: _showFrontSide ? _buildFront() : _buildRear(),
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashCardState = ref.watch(flashCardProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${flashCardState.indexQuestion + 1} of ${widget.kanjiFromApi.example.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  constraints: BoxConstraints.tight(Size.square(200.0)),
                  child: _buildFlipAnimation()),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(flashCardProvider.notifier).incrementIndex();
              controller.jumpToPage(0);
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: Text(ref.read(flashCardProvider.notifier).isTheLastQuestion()
                ? 'Restart the quiz'
                : 'Next'),
          )
        ]),
      ),
    );
  }
}
