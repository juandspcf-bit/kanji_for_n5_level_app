import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';

class TitleMainScreenNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return "";
  }

  void getTitle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      (() async {
        final uuid = ref.read(authServiceProvider).userUuid;

        final userData =
            await ref.read(cloudDBServiceProvider).readUserData(uuid ?? '');
        final fullName = 'Welcome\n ${userData.firstName} ${userData.lastName}';

        return Future(() => fullName);
      }),
    );
  }
}

final titleMainScreenProvider =
    AsyncNotifierProvider<TitleMainScreenNotifier, String>(
        TitleMainScreenNotifier.new);
