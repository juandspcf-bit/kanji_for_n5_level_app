import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorDatabaseStatusProvider extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setDeletingError(bool isError) {
    state = isError;
  }
}

final errorDatabaseStatusProvider =
    NotifierProvider<ErrorDatabaseStatusProvider, bool>(
        ErrorDatabaseStatusProvider.new);
