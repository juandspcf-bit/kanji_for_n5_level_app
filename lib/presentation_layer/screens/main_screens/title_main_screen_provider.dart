import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

part "title_main_screen_provider.g.dart";

@Riverpod(keepAlive: true)
class TitleMainScreen extends _$TitleMainScreen {
  @override
  FutureOr<String> build() async {
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
  }
}
