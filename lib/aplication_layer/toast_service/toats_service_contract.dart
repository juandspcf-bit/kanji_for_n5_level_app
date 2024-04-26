import 'package:flutter/material.dart';

abstract class ToastServiceContract {
  void showMessage(
    BuildContext context,
    String message,
    IconData? iconData,
    Duration duration,
    String labelAction,
    void Function()? actionCallback,
  );
  void showShortMessage(BuildContext context, String message);
  void dismiss(BuildContext context);
}
