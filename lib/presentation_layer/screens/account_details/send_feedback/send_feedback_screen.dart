import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/send_feedback/send_feedback_provider.dart';

class SendFeedBack extends ConsumerWidget {
  const SendFeedBack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.sendYourFeedback,
        ),
      ),
      body: SafeArea(child: SendFeedBackForm()),
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
                        labelText: context.l10n.subject,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (text) {
                        if (text != null && text.length >= 4) {
                          return null;
                        } else {
                          return context.l10n.textTooShort;
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
                          labelText: context.l10n.message,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                      validator: (text) {
                        if (text != null && text.length >= 4) {
                          return null;
                        } else {
                          return context.l10n.textTooShort;
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
                        minimumSize: const WidgetStatePropertyAll(
                          Size.fromHeight(40),
                        ),
                      ),
                      child: Text(context.l10n.send),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
