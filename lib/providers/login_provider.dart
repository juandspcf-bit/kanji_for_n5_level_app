import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginProvider extends Notifier<LogingData> {
  @override
  LogingData build() {
    return LogingData(statusFetching: 1);
  }

  void setStatus(int status) async {
    state = LogingData(statusFetching: status);
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LogingData>(LoginProvider.new);

class LogingData {
  final int statusFetching;

  LogingData({required this.statusFetching});
}
