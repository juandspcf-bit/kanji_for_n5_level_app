import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/change_email/change_email_flow_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';

class EmailChangeFlow extends ConsumerWidget with MyDialogs {
  const EmailChangeFlow({super.key});

  Widget _dialogPassworRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    void onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return;
      if (currenState.validate()) {
        currenState.save();
        Navigator.of(context).pop();
        ref
            .read(emailChangeProvider.notifier)
            .setStatusProcessing(StatusProcessingEmailChangeFlow.form);
        ref.read(emailChangeProvider.notifier).updateEmail(
              textPassword,
            );
      }
    }

    return AlertDialog(
      title: const Text('Type your password'),
      content: Form(
        key: dialogFormKey,
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            label: Text('password'),
            suffixIcon: Icon(Icons.key),
            border: OutlineInputBorder(),
          ),
          validator: (text) {
            if (text != null && text.length >= 4 && text.length <= 20) {
              return null;
            } else {
              return 'Invalid password';
            }
          },
          onSaved: (value) {
            if (value == null) return;
            textPassword = value;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ref
                .read(emailChangeProvider.notifier)
                .setStatusProcessing(StatusProcessingEmailChangeFlow.form);
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            onValidatePassword(context, ref);
          },
          child: const Text("Okay"),
        ),
      ],
    );
  }

  void _passworRequestDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return _dialogPassworRequest(buildContext, ref);
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final transformedAnimation =
            a1.drive(CurveTween(curve: Curves.decelerate));
        final value = transformedAnimation.value;
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<EmailChangeFlowData>(emailChangeProvider, (previous, current) {
      if (current.statusProcessing ==
          StatusProcessingEmailChangeFlow.showEmailInput) {
        _passworRequestDialog(context, ref);
      }
      if (current.statusProcessing ==
          StatusProcessingEmailChangeFlow.noMatchEmails) {
        errorDialog(context, () {
          ref
              .read(emailChangeProvider.notifier)
              .setStatusProcessing(StatusProcessingEmailChangeFlow.form);
        }, 'emails not match');
      }

      /* 
      

      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.error) {
        errorDialog(context, () {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        }, 'an error happend during updating process');
      }

      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.succsess) {
        successDialog(context, () {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        }, 'succeful updating process');
      } */
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: EmailChange(),
      ),
    );
  }
}

class EmailChange extends ConsumerWidget {
  EmailChange({
    super.key,
  });

  void onValidation(WidgetRef ref) {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (ref.read(emailChangeProvider).email ==
        ref.read(emailChangeProvider).confirmEmail) {
      ref
          .read(emailChangeProvider.notifier)
          .setStatusProcessing(StatusProcessingEmailChangeFlow.showEmailInput);
    } else {
      ref
          .read(emailChangeProvider.notifier)
          .setStatusProcessing(StatusProcessingEmailChangeFlow.noMatchEmails);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue: '',
                    decoration: const InputDecoration(
                      label: Text('Your email'),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.email_rounded),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (email) {
                      if (email != null && EmailValidator.validate(email)) {
                        return null;
                      } else {
                        return 'Not a valid email';
                      }
                    },
                    onSaved: (text) {
                      if (text != null) {
                        ref.read(emailChangeProvider.notifier).setEmail(text);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue: '',
                    decoration: const InputDecoration(
                      label: Text('Confirm your email'),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.email_rounded),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (email) {
                      if (email != null && EmailValidator.validate(email)) {
                        return null;
                      } else {
                        return 'Not a valid email';
                      }
                    },
                    onSaved: (text) {
                      if (text != null) {
                        ref
                            .read(emailChangeProvider.notifier)
                            .setConfirmEmail(text);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onValidation(ref);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Change your email'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
