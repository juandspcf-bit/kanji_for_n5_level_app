import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_rails/main_content_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_bottom/main_content_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

class MainContent extends ConsumerWidget with StatusDBStoringDialogs {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    var navigationBarMode = NavBarMode.bottom;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          navigationBarMode = NavBarMode.rail;
        }
      case (_, ScreenSizeWidth.extraLarge):
        navigationBarMode = NavBarMode.bottom;
      case (_, ScreenSizeWidth.large):
        navigationBarMode = NavBarMode.bottom;
      case (_, _):
        navigationBarMode = NavBarMode.bottom;
    }

    ref.listen<ErrorDownloadKanji>(errorDownloadProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an error downloading ${current.kanjiCharacter}");
    });

    ref.listen<ErrorDeleteKanji>(errorDeleteProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "There was an error deleting ${current.kanjiCharacter}");
    });

    ref.listen<PasswordChangeFlowData>(
      passwordChangeFlowProvider,
      (previous, current) {
        ref.read(toastServiceProvider).dismiss(context);
        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.noMatchPasswords) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                'passwords not match',
                Icons.error,
                const Duration(seconds: 3),
                "",
                null,
              );
        }

        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.error) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                'an error happened during updating process',
                Icons.error,
                const Duration(seconds: 3),
                "",
                null,
              );
        }

        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.success) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                'successful updating process',
                Icons.done,
                const Duration(seconds: 3),
                "",
                null,
              );
        }
      },
    );

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      if (current.updatingStatus == PersonalInfoUpdatingStatus.error) {
        ref.read(toastServiceProvider).dismiss(context);
        ref
            .read(personalInfoProvider.notifier)
            .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(toastServiceProvider).showMessage(
              context,
              'an error happened during updating process',
              Icons.error,
              const Duration(seconds: 3),
              "",
              null,
            );
      }

      if (current.updatingStatus == PersonalInfoUpdatingStatus.success) {
        ref.read(toastServiceProvider).dismiss(context);
        ref
            .read(personalInfoProvider.notifier)
            .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(toastServiceProvider).showMessage(
              context,
              'successful updating process',
              Icons.done,
              const Duration(seconds: 3),
              "",
              null,
            );
      }

      if (current.updatingStatus == PersonalInfoUpdatingStatus.noUpdate) {
        ref.read(toastServiceProvider).dismiss(context);
        ref
            .read(personalInfoProvider.notifier)
            .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(toastServiceProvider).showMessage(
              context,
              'nothing to update',
              Icons.question_mark,
              const Duration(seconds: 3),
              "",
              null,
            );
      }
    });

    return navigationBarMode == NavBarMode.bottom
        ? const MainContentPortrait()
        : const MainContentLandScape();
  }
}

enum NavBarMode {
  bottom,
  rail,
}
