import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/utils/networking/networking.dart';

class AvatarMainScreenNotifier
    extends AsyncNotifier<(ConnectionStatus, String)> {
  @override
  FutureOr<(ConnectionStatus, String)> build() {
    final connection = ref.read(statusConnectionProvider);
    return (connection, "");
  }

  void getLink() async {
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
            return (connection, user['pathAvatar'] as String);
          }
          return (connection, "");
        } else {
          final avatarLink = await ref
              .read(storageServiceProvider)
              .getDownloadLink(uuid ?? '');

          downloadAndCacheAvatar(uuid ?? '', avatarLink).then((value) => null);

          return (connection, avatarLink);
        }
      }),
    );
  }
}

final avatarMainScreenProvider =
    AsyncNotifierProvider<AvatarMainScreenNotifier, (ConnectionStatus, String)>(
        AvatarMainScreenNotifier.new);
