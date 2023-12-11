import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider extends Notifier<OnBoardingData> {
  @override
  OnBoardingData build() {
    SharedPreferences.getInstance().then((prefs) {
      final bool? isOnBoardingDone = prefs.getBool('isOnBoardingDone');
      state = OnBoardingData(prefs: prefs, isOnBoardingDone: isOnBoardingDone);
    }).onError((error, stackTrace) {
      state = OnBoardingData(prefs: null, isOnBoardingDone: null);
    });

    return OnBoardingData(prefs: null, isOnBoardingDone: null);
  }

  void setOnBoardingDone() async {
    final prefs = state.prefs;
    if (prefs != null) {
      await prefs.setBool('isOnBoardingDone', true);
      state = OnBoardingData(prefs: state.prefs, isOnBoardingDone: true);
    }
  }
}

final onBoardingProvider = NotifierProvider<OnBoardingProvider, OnBoardingData>(
    OnBoardingProvider.new);

class OnBoardingData {
  final SharedPreferences? prefs;
  final bool? isOnBoardingDone;

  OnBoardingData({required this.prefs, required this.isOnBoardingDone});
}
