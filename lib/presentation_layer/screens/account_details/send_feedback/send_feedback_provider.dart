import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendFeedbackNotifier extends Notifier<SendFeedbackData> {
  @override
  SendFeedbackData build() {
    return SendFeedbackData(message: '', subject: '');
  }

  void setMessage(String message) {
    state = SendFeedbackData(message: message, subject: state.subject);
  }

  void setSubject(String subject) {
    state = SendFeedbackData(message: state.message, subject: subject);
  }

  void sendEmail() async {
    final Email email = Email(
      body: state.message,
      subject: state.subject,
      recipients: ['juandspcf@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}

final sendFeedbackNotifier =
    NotifierProvider<SendFeedbackNotifier, SendFeedbackData>(
        SendFeedbackNotifier.new);

class SendFeedbackData {
  final String message;
  final String subject;

  SendFeedbackData({
    required this.message,
    required this.subject,
  });
}
