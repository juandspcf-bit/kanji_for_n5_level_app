import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/toast_service/toats_service_contract.dart';

class DelightfulToastService extends ToastServiceContract {
  @override
  void dismiss() {
    return;
  }

  @override
  void showMessage(BuildContext context) {
    return;
  }

  @override
  void showNoWifiConnection(BuildContext context) {
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      builder: (context) => ToastCard(
        color: Theme.of(context).colorScheme.secondaryContainer,
        leading: const Icon(
          Icons.wifi,
          size: 28,
        ),
        title: const Text(
          'No internet connection',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }

  @override
  void showWifiConnection(BuildContext context) {
    DelightToastBar(
      position: DelightSnackbarPosition.bottom,
      builder: (context) => ToastCard(
        color: Theme.of(context).colorScheme.secondaryContainer,
        leading: const Icon(
          Icons.wifi,
          size: 28,
        ),
        title: const Text(
          'Internet connection restored',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    ).show(context);
  }
}
