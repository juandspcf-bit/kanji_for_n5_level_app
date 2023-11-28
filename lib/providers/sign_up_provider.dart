import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class SingUpProvider extends Notifier<SingUpData> {
  @override
  SingUpData build() {
    return SingUpData(statusFetching: 1);
  }

  void setStatus(int status) async {
    state = SingUpData(statusFetching: status);
  }

  void onValidate(
    GlobalKey<FormState> formKey,
    String pathProfileUser,
    String fullName,
    String emailAddress,
    String password1,
    String password2,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      if (password1 == password2) {
        formKey.currentState!.save();

        setStatus(1);

        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password1,
          );

          final user = credential.user;

          if (user != null) {
            user.updateDisplayName(fullName);
            user.updateEmail(emailAddress);
          }

          if (pathProfileUser.isNotEmpty) {
            try {
              final userPhoto =
                  storageRef.child("userImages/${credential.user!.uid}.jpg");

              await userPhoto.putFile(File(pathProfileUser));
            } catch (e) {
              logger.e('error');
              logger.e(e);
            }
          }

          setStatus(0);

          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            logger.d('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            logger.d('The account already exists for that email.');
          }
        } catch (e) {
          logger.e(e);
        } finally {
          setStatus(0);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords should match'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

final singUpProvider =
    NotifierProvider<SingUpProvider, SingUpData>(SingUpProvider.new);

class SingUpData {
  final int statusFetching;

  SingUpData({required this.statusFetching});
}
