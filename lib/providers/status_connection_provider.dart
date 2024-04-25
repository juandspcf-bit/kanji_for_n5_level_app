import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

class StatusConnectionProvider extends Notifier<ConnectionStatus> {
  StreamSubscription<bool>? subscription;
  @override
  ConnectionStatus build() {
/*     final connectionState = Connectivity();

    connectionState.checkConnectivity().then(
      (value) {
        subscription = connectionState.onConnectivityChanged
            .listen((ConnectivityResult result) {
          state = result;
          logger.d('Connections $state');
/*         FlutterLogs.logThis(
            tag: 'MyApp',
            subTag: 'logData',
            logMessage:
                'This is a log message: Connections $result ${DateTime.now().millisecondsSinceEpoch}',
            level: LogLevel.INFO); */
        });
        state = value;
      },
    );
    return ConnectivityResult.other; */
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

final statusConnectionProvider =
    NotifierProvider<StatusConnectionProvider, ConnectionStatus>(
        StatusConnectionProvider.new);

enum ConnectionStatus { connected, noConnected }
