import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashCardProvider extends Notifier<FlashCardData> {
  @override
  FlashCardData build() {
    return FlashCardData(showFrontSide: true);
  }

  void toggleState() {
    state = FlashCardData(showFrontSide: !state.showFrontSide);
  }

  void restartSide() {
    state = FlashCardData(showFrontSide: true);
  }
}

final flashCardWidgetProvider =
    NotifierProvider<FlashCardProvider, FlashCardData>(FlashCardProvider.new);

class FlashCardData {
  final bool showFrontSide;

  FlashCardData({required this.showFrontSide});
}
