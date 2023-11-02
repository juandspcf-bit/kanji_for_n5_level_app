import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorStatusAfterProcessingStorage extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  setStatusProcessing(bool value) {
    state = value;
  }
}

final errorStatusAfterProcessingStorage =
    NotifierProvider<ErrorStatusAfterProcessingStorage, bool>(
        ErrorStatusAfterProcessingStorage.new);
