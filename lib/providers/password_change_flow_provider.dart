import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordChangeFlowProvider extends Notifier<PasswordChangeFlowData> {
  @override
  PasswordChangeFlowData build() {
    return PasswordChangeFlowData(statusProcessing: StatusProcessing.form);
  }
}

class PasswordChangeFlowData {
  final StatusProcessing statusProcessing;

  PasswordChangeFlowData({required this.statusProcessing});
}

final passwordChangeFlowProvider =
    NotifierProvider<PasswordChangeFlowProvider, PasswordChangeFlowData>(
        PasswordChangeFlowProvider.new);

enum StatusProcessing {
  updating,
  error,
  succsess,
  form,
}
