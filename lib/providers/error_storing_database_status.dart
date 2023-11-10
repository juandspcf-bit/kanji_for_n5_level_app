import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorStoringDatabaseStatus extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setError(bool isError) {
    state = isError;
  }
}

final errorStoringDatabaseStatus =
    NotifierProvider<ErrorStoringDatabaseStatus, bool>(
        ErrorStoringDatabaseStatus.new);
