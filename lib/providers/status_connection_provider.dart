import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

part 'status_connection_provider.g.dart';

@Riverpod(keepAlive: true)
class StatusConnection extends _$StatusConnection {
  StreamSubscription<bool>? subscription;
  @override
  ConnectionStatus build() {
    subscription = InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
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

enum ConnectionStatus { connected, noConnected }
