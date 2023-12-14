import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';

mixin DialogErrorInDB {
  Widget _dialogDBError(BuildContext buildContext, WidgetRef ref) {
    return AlertDialog(
      title: const Text(
          'An issue happened when deleting this item, please go back to the section list and access the content again to see the updated content.'),
      content: const Icon(
        Icons.error_rounded,
        color: Colors.amberAccent,
        size: 70,
      ),
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

  void dbDeletingErrorDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialogDBError(buildContext, ref),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
