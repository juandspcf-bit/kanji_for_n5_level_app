import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavigationRailsDetailsProvider
    extends Notifier<CustomNavigationRailsDetailsData> {
  @override
  CustomNavigationRailsDetailsData build() {
    return CustomNavigationRailsDetailsData(selection: 0);
  }

  int getSelection() {
    return state.selection;
  }

  void setSelection(int selection) {
    state = CustomNavigationRailsDetailsData(selection: selection);
  }
}

final customNavigationRailsDetailsProvider = NotifierProvider<
    CustomNavigationRailsDetailsProvider,
    CustomNavigationRailsDetailsData>(CustomNavigationRailsDetailsProvider.new);

class CustomNavigationRailsDetailsData {
  int selection;
  CustomNavigationRailsDetailsData({
    required this.selection,
  });
}
