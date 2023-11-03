import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusConnectionProvider extends Notifier<ConnectivityResult> {
  StreamSubscription? subscription;
  @override
  ConnectivityResult build() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      state = result;
    });
    return ConnectivityResult.none;
  }

  void setInitialStatus(ConnectivityResult result) {
    state = result;
  }
}

final statusConnectionProvider =
    NotifierProvider<StatusConnectionProvider, ConnectivityResult>(
        StatusConnectionProvider.new);
