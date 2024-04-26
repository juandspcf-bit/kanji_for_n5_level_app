import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

class StatusConnectionProvider extends Notifier<ConnectionStatus> {
  StreamSubscription<bool>? subscription;
  @override
  ConnectionStatus build() {
    subscription = InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      logger.d('has internet stream $hasInternetAccess');
      if (!hasInternetAccess) {
        state = ConnectionStatus.noConnected;
      } else {
        state = ConnectionStatus.connected;
      }
    });

    ref.onDispose(() {
      subscription?.cancel();
    });

    return ConnectionStatus.connected;
  }

  void setInitialStatus(ConnectionStatus result) {
    state = result;
  }
}

final statusConnectionProvider =
    NotifierProvider<StatusConnectionProvider, ConnectionStatus>(
        StatusConnectionProvider.new);

enum ConnectionStatus { connected, noConnected }
