import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/send_feedback/send_feedback_provider.dart';

class SendFeedBack extends ConsumerWidget {
  const SendFeedBack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send your feedback'),
      ),
      body: SendFeedBackForm(),
    );
  }
}

class SendFeedBackForm extends ConsumerWidget {
  SendFeedBackForm({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  void onValidation(BuildContext context, WidgetRef ref) async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
    ref.read(sendFeedbackNotifier.notifier).sendEmail();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.feedback,
                color: Colors.amber,
                size: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration().copyWith(
                          border: const OutlineInputBorder(),
                          labelText: 'Subject',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (text) {
                          if (text != null && text.length >= 4) {
                            return null;
                          } else {
                            return 'Text should not be too short';
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            ref
                                .read(sendFeedbackNotifier.notifier)
                                .setSubject(value);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        minLines: 6,
                        maxLines: 6,
                        decoration: const InputDecoration().copyWith(
                            border: const OutlineInputBorder(),
                            labelText: 'message',
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        validator: (text) {
                          if (text != null && text.length >= 4) {
                            return null;
                          } else {
                            return 'Text should not be too short';
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            ref
                                .read(sendFeedbackNotifier.notifier)
                                .setMessage(value);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                          onValidation(context, ref);
                        },
                        style: ElevatedButton.styleFrom().copyWith(
                          minimumSize: const MaterialStatePropertyAll(
                            Size.fromHeight(40),
                          ),
                        ),
                        child: const Text('Send'),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
