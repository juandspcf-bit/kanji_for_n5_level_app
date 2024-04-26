import 'package:flutter/material.dart';

abstract class ToastServiceContract {
  void showMessage(
      BuildContext context, String message, Icon icon, void Function()? action);
  void showShortMessage(BuildContext context, String message);
  void dismiss(BuildContext context);
}
