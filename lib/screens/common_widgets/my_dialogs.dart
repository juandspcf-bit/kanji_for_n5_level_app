import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        return _myBaseDialog(ctx, action, message, icon);
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final transformedAnimation =
            a1.drive(CurveTween(curve: Curves.decelerate));
        final value = transformedAnimation.value;
        //var value = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: value,
          child: child,
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

void showPasswordRequestTextField({
  required BuildContext context,
  required WidgetRef ref,
  required Function(String password) okayAction,
  required Function() cancelAction,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: _dialogPassworRequest(
          context: context,
          ref: ref,
          okayAction: okayAction,
          cancelAction: cancelAction,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

Widget _dialogPassworRequest({
  required BuildContext context,
  required WidgetRef ref,
  required Function(String password) okayAction,
  required Function() cancelAction,
}) {
  final dialogFormKey = GlobalKey<FormState>();
  var textPassword = '';
  bool onValidatePassword(BuildContext context, WidgetRef ref) {
    final currenState = dialogFormKey.currentState;
    if (currenState == null) return false;
    final isValid = currenState.validate();
    if (isValid) currenState.save();
    return isValid;
  }

  return AlertDialog(
    title: const Text('Type your password'),
    content: Form(
      key: dialogFormKey,
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          label: Text('password'),
          suffixIcon: Icon(Icons.key),
          border: OutlineInputBorder(),
        ),
        validator: (text) {
          if (text != null && text.length >= 4 && text.length <= 20) {
            return null;
          } else {
            return 'Invalid password';
          }
        },
        onSaved: (value) {
          if (value == null) return;
          textPassword = value;
        },
      ),
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          cancelAction();
          Navigator.of(context).pop();
        },
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () {
          if (onValidatePassword(context, ref)) {
            okayAction(textPassword);
            Navigator.of(context).pop();
          }
        },
        child: const Text("Okay"),
      ),
    ],
  );
}
