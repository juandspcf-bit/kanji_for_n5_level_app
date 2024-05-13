import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

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

        final connection = ref.read(statusConnectionProvider);

        if (connection == ConnectionStatus.noConnected) {
          final listUser = await ref
              .read(localDBServiceProvider)
              .readUserData(ref.read(authServiceProvider).userUuid ?? '');
          if (listUser.isNotEmpty) {
            final user = listUser.first;
            final firstName = user['firstName'] as String;
            final lastName = user['lastName'] as String;
            final fullName = "$firstName $lastName";
            return fullName;
          }
          return "";
        } else {
          final userData =
              await ref.read(cloudDBServiceProvider).readUserData(uuid ?? '');
          final fullName = '${userData.firstName} ${userData.lastName}';

          return fullName;
        }
      }),
    );
  }
}

final titleMainScreenProvider =
    AsyncNotifierProvider<TitleMainScreenNotifier, String>(
        TitleMainScreenNotifier.new);
