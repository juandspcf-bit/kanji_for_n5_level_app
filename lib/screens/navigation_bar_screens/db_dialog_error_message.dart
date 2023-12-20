import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';

mixin MyDialogs {
  Widget _myBaseDialog(
      BuildContext buildContext, WidgetRef ref, String message, Icon icon) {
    return AlertDialog(
      title: Text(message),
      content: icon,
      actions: <Widget>[
        TextButton(
            onPressed: () {
              ref
                  .read(errorDatabaseStatusProvider.notifier)
                  .setDeletingError(false);
              Navigator.of(buildContext).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void errorDialog(
    BuildContext buildContext,
    WidgetRef ref,
    String message,
    Icon icon,
  ) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _myBaseDialog(buildContext, ref, message, icon),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
