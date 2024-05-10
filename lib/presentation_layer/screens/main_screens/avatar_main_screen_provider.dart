import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/utils/networking/networking.dart';

class AvatarMainScreenNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return "";
  }

  void getLink() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      (() async {
        final uuid = ref.read(authServiceProvider).userUuid;

        final avatarLink =
            await ref.read(storageServiceProvider).getDownloadLink(uuid ?? '');

        downloadAndCacheAvatar(uuid ?? '', avatarLink).then((value) => null);

        return Future(() => avatarLink);
      }),
    );
  }
}

final avatarMainScreenProvider =
    AsyncNotifierProvider<AvatarMainScreenNotifier, String>(
        AvatarMainScreenNotifier.new);
