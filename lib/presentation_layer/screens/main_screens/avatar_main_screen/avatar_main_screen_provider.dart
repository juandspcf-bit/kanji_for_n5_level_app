import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/utils/networking/networking.dart';

part "avatar_main_screen_provider.g.dart";

@riverpod
class AvatarMainScreen extends _$AvatarMainScreen {
  @override
  FutureOr<(ConnectionStatus, String)> build() async {
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
      try {
        final avatarLink =
            await ref.read(storageServiceProvider).getDownloadLink(uuid ?? '');

        downloadAndCacheAvatar(uuid ?? '', avatarLink).then((value) => null);
        return (connection, avatarLink);
      } catch (e) {
        return (connection, "");
      }
    }
  }
}
