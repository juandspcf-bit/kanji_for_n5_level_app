import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/toast_service/toats_service_contract.dart';
import 'package:toastification/toastification.dart';

class ToastificationService extends ToastServiceContract {
  ToastificationItem? notification;

  @override
  void dismiss() {
    if (notification != null) {
      toastification.dismiss(notification!);
    }
  }

  @override
  void showMessage(BuildContext context) {
    // TODO: implement showMessage
  }

  @override
  void showNoWifiConnection(BuildContext context) {
    notification = toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: 'No internet connection',
      alignment: Alignment.bottomLeft,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(
        Icons.wifi_off,
        color: Colors.red[300],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }

  @override
  void showWifiConnection(BuildContext context) {
    notification = toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: 'Internet connection restored',
      alignment: Alignment.bottomLeft,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.wifi,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(10),
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
