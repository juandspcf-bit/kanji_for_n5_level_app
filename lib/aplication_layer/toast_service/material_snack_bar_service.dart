import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/toast_service/toats_service_contract.dart';

class MaterialSnackBarService extends ToastServiceContract {
  @override
  void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  void showMessage(BuildContext context, String message, Icon icon,
      void Function()? action) {
    var snackBar = SnackBar(
      content: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(message),
        ],
      ),
      duration: const Duration(days: 1),
      action: action == null
          ? null
          : SnackBarAction(label: 'Undo', onPressed: () async {}),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void showShortMessage(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
