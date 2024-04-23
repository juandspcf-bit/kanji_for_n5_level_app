import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class StatusConnectionProvider extends Notifier<ConnectivityResult> {
  StreamSubscription? subscription;
  @override
  ConnectivityResult build() {
    final connectionState = Connectivity();

    connectionState.checkConnectivity().then((value) {
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
    });
    return ConnectivityResult.other;
  }

  void setInitialStatus(ConnectivityResult result) {
    state = result;
  }
}

final statusConnectionProvider =
    NotifierProvider<StatusConnectionProvider, ConnectivityResult>(
        StatusConnectionProvider.new);
