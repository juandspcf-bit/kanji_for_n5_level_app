import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider extends Notifier<OnBoardingData> {
  @override
  OnBoardingData build() {
    SharedPreferences.getInstance().then((preferences) {
      final bool? isOnBoardingDone = preferences.getBool('isOnBoardingDone');
      state = OnBoardingData(
          preferences: preferences, isOnBoardingDone: isOnBoardingDone);
    }).onError((error, stackTrace) {
      state = OnBoardingData(preferences: null, isOnBoardingDone: null);
    });

    return OnBoardingData(preferences: null, isOnBoardingDone: null);
  }

  void setOnBoardingDone() async {
    final preferences = state.preferences;
    if (preferences != null) {
      await preferences.setBool('isOnBoardingDone', true);
      state = OnBoardingData(
          preferences: state.preferences, isOnBoardingDone: true);
    }
  }
}

final onBoardingProvider = NotifierProvider<OnBoardingProvider, OnBoardingData>(
    OnBoardingProvider.new);

class OnBoardingData {
  final SharedPreferences? preferences;
  final bool? isOnBoardingDone;

  OnBoardingData({required this.preferences, required this.isOnBoardingDone});
}
