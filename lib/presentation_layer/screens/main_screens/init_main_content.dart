import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class InitMainContent extends ConsumerWidget {
  const InitMainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return FutureBuilder(
      future: ref.read(statusConnectionProvider) == ConnectionStatus.noConnected
          ? ref.read(mainScreenProvider.notifier).initAppOffline()
          : ref.read(mainScreenProvider.notifier).initAppOnline(),
      builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
        final connectionStatus = snapShot.connectionState;
        if (connectionStatus == ConnectionState.waiting) {
          return const Scaffold(
            body: ProcessProgress(
              message: 'Loading',
            ),
          );
        } else if (connectionStatus == ConnectionState.done ||
            connectionStatus == ConnectionState.active) {
          return const MainContent();
        } else {
          return const Center(child: Text('error'));
        }
      },
    );
  }
}
