import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/application_layer/toast_service/toast_service_contract.dart';

class MaterialSnackBarService extends ToastServiceContract {
  @override
  void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  void showMessage(
    BuildContext context,
    String message,
    IconData? iconData,
    Duration duration,
    String labelAction,
    void Function()? actionCallback,
  ) {
    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      dismissDirection: DismissDirection.endToStart,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Row(
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: Colors.amber,
            ),
          const SizedBox(
            width: 10,
          ),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      duration: duration,
      action: actionCallback == null
          ? null
          : SnackBarAction(
              label: labelAction,
              textColor: Colors.white,
              onPressed: () async {
                actionCallback();
              }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void showShortMessage(BuildContext context, String message) {
    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      dismissDirection: DismissDirection.endToStart,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
