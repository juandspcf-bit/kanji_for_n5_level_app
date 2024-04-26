import 'package:flutter/material.dart';

abstract class ToastServiceContract {
  void showWifiConnection(BuildContext context);
  void showNoWifiConnection(BuildContext context);
  void showMessage(BuildContext context);
  void dismiss();
}
