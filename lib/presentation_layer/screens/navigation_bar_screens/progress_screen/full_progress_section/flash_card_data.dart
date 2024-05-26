import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';

class FlashCardSectionData extends StatelessWidget {
  const FlashCardSectionData({
    super.key,
    required this.singleQuizFlashCardData,
    required this.kanjiCharacter,
  });

  final List<SingleQuizFlashCardData> singleQuizFlashCardData;
  final String kanjiCharacter;

  @override
  Widget build(BuildContext context) {
    bool allRevisedFlashCards;
    try {
      final data = singleQuizFlashCardData
          .firstWhere((data) => data.kanjiCharacter == kanjiCharacter);
      allRevisedFlashCards = data.allRevisedFlashCards;
    } catch (e) {
      allRevisedFlashCards = false;
    }

    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "flash cards progress",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              width: 30,
            ),
            allRevisedFlashCards
                ? SvgPicture.asset(
                    "assets/icons/done.svg",
                    width: 50,
                    height: 50,
                  )
                : SvgPicture.asset(
                    "assets/icons/undone_red.svg",
                    width: 50,
                    height: 50,
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(allRevisedFlashCards ? "all revised" : "not all revised"),
          ]),
        ],
      ),
    );
  }
}
