import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/change_email/change_email_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class EmailChangeFlow extends ConsumerWidget {
  const EmailChangeFlow({super.key});

  Widget _dialogPasswordRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    void onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return;
      if (currenState.validate()) {
        currenState.save();
        Navigator.of(context).pop();
        ref.read(emailChangeProvider.notifier).updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.form);
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
            ref.read(emailChangeProvider.notifier).updateState(
                statusProcessing: StatusProcessingEmailChangeFlow.form);
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

  void _passwordRequestDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return _dialogPasswordRequest(buildContext, ref);
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
        _passwordRequestDialog(context, ref);
      }
      if (current.statusProcessing ==
          StatusProcessingEmailChangeFlow.noMatchEmails) {
        ref.read(toastServiceProvider).showMessage(
              context,
              'emails not match',
              Icons.error,
              const Duration(seconds: 3),
              "",
              null,
            );
        ref.read(emailChangeProvider.notifier).updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.form);
      }

      if (current.statusProcessing == StatusProcessingEmailChangeFlow.error) {
        ref.read(toastServiceProvider).showMessage(
              context,
              'An error happened during changing your email',
              Icons.error,
              const Duration(seconds: 3),
              "",
              null,
            );
        ref.read(emailChangeProvider.notifier).updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.form);
      }

      if (current.statusProcessing == StatusProcessingEmailChangeFlow.success) {
        ref.read(toastServiceProvider).showMessage(
              context,
              'successful sent link to change your email',
              Icons.check_circle,
              const Duration(seconds: 5),
              "",
              null,
            );
        ref.read(emailChangeProvider.notifier).updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.form);
        ref.read(authServiceProvider).singOut().then((data) {
          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
          ref.read(mainScreenProvider.notifier).resetMainScreenState();
          ref.read(loginProvider.notifier).resetData();
          ref
              .read(loginProvider.notifier)
              .setStatusLoggingFlow(StatusProcessingLoggingFlow.form);
        });
      }
    });

    return PopScope(
      canPop: !(ref.watch(emailChangeProvider).statusProcessing ==
          StatusProcessingEmailChangeFlow.updating),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: EmailChange(),
        ),
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
      ref.read(emailChangeProvider.notifier).updateState(
          statusProcessing: StatusProcessingEmailChangeFlow.showEmailInput);
    } else {
      ref.read(emailChangeProvider.notifier).updateState(
          statusProcessing: StatusProcessingEmailChangeFlow.noMatchEmails);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConnectionData = ref.watch(statusConnectionProvider);
    final stateEmailChange = ref.watch(emailChangeProvider);
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
                    initialValue: stateEmailChange.email,
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
                        ref
                            .read(emailChangeProvider.notifier)
                            .updateState(email: text);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    initialValue: stateEmailChange.confirmEmail,
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
                            .updateState(confirmEmail: text);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed:
                        statusConnectionData == ConnectionStatus.noConnected
                            ? null
                            : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                onValidation(ref);
                              },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: stateEmailChange.statusProcessing ==
                            StatusProcessingEmailChangeFlow.updating
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : const Text("Change your email"),
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
