import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'on_boarding_provider.g.dart';

@riverpod
class OnBoardingFlow extends _$OnBoardingFlow {
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

class OnBoardingData {
  final SharedPreferences? preferences;
  final bool? isOnBoardingDone;

  OnBoardingData({required this.preferences, required this.isOnBoardingDone});
}
