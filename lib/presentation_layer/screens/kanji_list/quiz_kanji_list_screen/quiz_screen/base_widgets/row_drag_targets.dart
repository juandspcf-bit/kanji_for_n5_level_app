import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_screen/base_widgets/custom_drag_target.dart';

class RowDragTargets extends ConsumerWidget {
  const RowDragTargets({
    super.key,
    required this.isDragged,
    required this.randomSolutions,
    required this.kanjiToAskMeaning,
    required this.imagePathFromDraggedItem,
    required this.initialOpacities,
  });

  final bool isDragged;
  final List<KanjiFromApi> randomSolutions;
  final KanjiFromApi kanjiToAskMeaning;
  final List<String> imagePathFromDraggedItem;
  final List<double> initialOpacities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...getDragTargets(context),
      ],
    );
  }

  List<Widget> getDragTargets(BuildContext context) {
    final widhtScreen = getScreenSizeWidth(context);

    int padding = 0;
    switch (widhtScreen) {
      case ScreenSizeWidth.extraLarge:
        padding = 60;
      case ScreenSizeWidth.large:
        padding = 50;
      case ScreenSizeWidth.normal:
        padding = 0;
      case (_):
        padding = 0;
    }
    List<Widget> widgets = [];

    for (int indexColumnTargets = 0;
        indexColumnTargets < randomSolutions.length;
        indexColumnTargets++) {
      if (widhtScreen != ScreenSizeWidth.normal) {
        widgets.add(SizedBox(
          width: padding.toDouble(),
        ));
      }
      widgets.add(CustomDragTarget(
          indexColumnTargets: indexColumnTargets,
          isDragged: isDragged,
          randomSolutions: randomSolutions,
          kanjiToAskMeaning: kanjiToAskMeaning,
          imagePathFromDraggedItem: imagePathFromDraggedItem,
          initialOpacities: initialOpacities));
    }
    return widgets;
  }
}
