import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class ChangePasswordButton extends ConsumerWidget {
  const ChangePasswordButton({super.key, required this.callback});

  final void Function() callback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordChangeFlow = ref.watch(passwordChangeFlowProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    return ElevatedButton(
      onPressed: statusConnectionData == ConnectionStatus.noConnected
          ? null
          : () {
              if (passwordChangeFlow.statusProcessing !=
                  StatusProcessingPasswordChangeFlow.updating) {
                callback();
              }
            },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
      child: passwordChangeFlow.statusProcessing ==
              StatusProcessingPasswordChangeFlow.updating
          ? SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(context.l10n.change),
    );
  }
}
