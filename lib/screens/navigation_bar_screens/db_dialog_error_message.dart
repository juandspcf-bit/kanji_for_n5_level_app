import 'package:flutter/material.dart';

mixin MyDialogs {
  Widget _myBaseDialog(BuildContext buildContext, void Function() action,
      String message, Icon icon) {
    return AlertDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      content: icon,
      actions: <Widget>[
        TextButton(
            onPressed: () {
              action();
              Navigator.of(buildContext).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void scaleDialog(
    BuildContext buildContext,
    void Function() action,
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
          child: _myBaseDialog(ctx, action, message, icon),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void errorDialog(
    BuildContext buildContext,
    void Function() action,
    String message,
  ) {
    scaleDialog(
      buildContext,
      action,
      message,
      const Icon(
        Icons.error_rounded,
        color: Colors.amberAccent,
        size: 70,
      ),
    );
  }

  void successDialog(
    BuildContext buildContext,
    void Function() action,
    String message,
  ) {
    scaleDialog(
      buildContext,
      action,
      message,
      const Icon(
        Icons.check_circle,
        color: Colors.amberAccent,
        size: 70,
      ),
    );
  }
}
