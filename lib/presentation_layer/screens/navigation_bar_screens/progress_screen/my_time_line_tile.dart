import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/my_tile.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  const MyTimeLineTile({
    super.key,
    required this.section,
    required this.isFirst,
    required this.isLast,
    required this.isFinishedKanjiQuizSection,
    required this.isAllCorrectKanjiQuizSection,
    required this.isFinishedAudioQuizSection,
    required this.isAllCorrectAudioQuizSection,
    required this.isFinishedFlashCardSection,
  });

  final int section;
  final bool isFirst;
  final bool isLast;
  final bool isFinishedKanjiQuizSection;
  final bool isAllCorrectKanjiQuizSection;
  final bool isFinishedAudioQuizSection;
  final bool isAllCorrectAudioQuizSection;
  final bool isFinishedFlashCardSection;

  (Color, Color, IconData) getColorsStatus() {
    if (isFinishedKanjiQuizSection &&
        isAllCorrectKanjiQuizSection &&
        isFinishedAudioQuizSection &&
        isAllCorrectAudioQuizSection &&
        isFinishedFlashCardSection) {
      return (
        Colors.amberAccent,
        Colors.deepPurple,
        Icons.military_tech_rounded
      );
    } else if (isFinishedKanjiQuizSection &&
        isFinishedAudioQuizSection &&
        isFinishedFlashCardSection) {
      return (
        const Color.fromARGB(255, 101, 172, 207),
        Colors.white,
        Icons.done
      );
    } else {
      return (Colors.deepPurple, Colors.white, Icons.sentiment_dissatisfied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (colorContainer, colorText, iconData) = getColorsStatus();
    return TimelineTile(
      indicatorStyle: IndicatorStyle(
        iconStyle: IconStyle(
          iconData: iconData,
          color: colorText,
        ),
        color: colorContainer,
        height: 50,
        width: 50,
      ),
      beforeLineStyle: LineStyle(color: colorContainer),
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      endChild: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${context.l10n.ordinal_numbers(section.toString())} ${context.l10n.section}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: colorText,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTile(
                icon: Icon(
                  isFinishedKanjiQuizSection ? Icons.done_rounded : Icons.close,
                  color: colorText,
                ),
                text: Text(
                  context.l10n.kanji_quiz_finished,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorText,
                      ),
                ),
              ),
              MyTile(
                icon: Icon(
                  isAllCorrectKanjiQuizSection
                      ? Icons.done_rounded
                      : Icons.close,
                  color: colorText,
                ),
                text: Text(
                  context.l10n.kanji_quiz_all_correct,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorText,
                      ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyTile(
                icon: Icon(
                  isFinishedAudioQuizSection ? Icons.done_rounded : Icons.close,
                  color: colorText,
                ),
                text: Text(
                  context.l10n.audio_quiz_finished,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorText,
                      ),
                ),
              ),
              MyTile(
                icon: Icon(
                  isAllCorrectAudioQuizSection
                      ? Icons.done_rounded
                      : Icons.close,
                  color: colorText,
                ),
                text: Text(
                  context.l10n.audio_quiz_all_correct,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorText,
                      ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyTile(
                icon: Icon(
                  isFinishedFlashCardSection ? Icons.done_rounded : Icons.close,
                  color: colorText,
                ),
                text: Text(
                  context.l10n.flash_card_finished,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colorText,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
