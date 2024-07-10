import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_favorite_kanjis_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class InitMainContent extends ConsumerStatefulWidget {
  const InitMainContent({super.key});

  @override
  ConsumerState<InitMainContent> createState() => InitMainContentState();
}

class InitMainContentState extends ConsumerState<InitMainContent> {
  late final Future<void> futureStored;

  @override
  void initState() {
    futureStored =
        ref.read(statusConnectionProvider) == ConnectionStatus.noConnected
            ? ref.read(mainScreenProvider.notifier).initAppOffline()
            : ref.read(mainScreenProvider.notifier).initAppOnline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ErrorDownloadKanji>(errorDownloadProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "${context.l10n.errorDownload} ${current.kanjiCharacter}");
    });

    ref.listen<ErrorDeleteKanji>(errorDeleteProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);
      ref.read(toastServiceProvider).showShortMessage(
          context, "${context.l10n.errorDeleting} ${current.kanjiCharacter}");
    });

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      if (current.updatingStatus == PersonalInfoUpdatingStatus.error) {
        ref.read(toastServiceProvider).dismiss(context);
        ref
            .read(personalInfoProvider.notifier)
            .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(toastServiceProvider).showMessage(
              context,
              context.l10n.updatingError,
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
              context.l10n.updatingSuccess,
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
              context.l10n.updatingNone,
              Icons.question_mark,
              const Duration(seconds: 3),
              "",
              null,
            );
      }
    });

    ref.listen<FavoritesKanjisData>(
      favoritesKanjisProvider,
      (prev, current) {
        logger.d(current.onDismissibleActionStatus.message);
        if (current.onDismissibleActionStatus ==
                OnDismissibleActionStatus.successAdded ||
            current.onDismissibleActionStatus ==
                OnDismissibleActionStatus.successRemoved ||
            current.onDismissibleActionStatus ==
                OnDismissibleActionStatus.error) {
          ref.read(toastServiceProvider).dismiss(context);

          ref.read(toastServiceProvider).showMessage(
              context,
              current.onDismissibleActionStatus.message,
              null,
              const Duration(seconds: 7),
              context.l10n.undo,
              current.onDismissibleActionStatus ==
                      OnDismissibleActionStatus.successAdded
                  ? null
                  : () async {
                      final dismissedKanji =
                          ref.read(favoritesKanjisProvider).dismissedKanji;

                      if (dismissedKanji == null) {
                        return;
                      }

                      await ref
                          .read(favoritesKanjisProvider.notifier)
                          .restoreFavorite(
                            dismissedKanji.kanjiFromApiFromDismissibleAction,
                            dismissedKanji.index,
                          );
                    });

          ref
              .read(favoritesKanjisProvider.notifier)
              .setOnDismissibleActionStatus(
                  OnDismissibleActionStatus.noStarted);
        }
      },
    );

    return FutureBuilder(
      future: futureStored,
      builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
        final connectionStatus = snapShot.connectionState;
        if (connectionStatus == ConnectionState.waiting) {
          return Scaffold(
            body: ProcessProgress(
              message: context.l10n.loading,
            ),
          );
        } else if (connectionStatus == ConnectionState.done ||
            connectionStatus == ConnectionState.active) {
          return const SafeArea(child: MainContent());
        } else {
          return Scaffold(body: Center(child: Text(context.l10n.errorLoading)));
        }
      },
    );
  }
}
