import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/use_cases/sing_in_user_firebase.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        name: '',
        email: '',
        statusFetching: 0,
        showPasswordRequest: false);
  }

  void resetData() {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        name: '',
        email: '',
        statusFetching: 0,
        showPasswordRequest: state.showPasswordRequest);
  }

  Future<void> getInitialPersonalInfoData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;
    final email = FirebaseAuth.instance.currentUser!.email;

    try {
      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      logger.e('reading profile photo');

      final photoLink =
          await userPhoto.getDownloadURL().timeout(const Duration(seconds: 10));
      state = PersonalInfoData(
          pathProfileUser: photoLink,
          pathProfileTemporal: '',
          name: fullName ?? '',
          email: email ?? '',
          statusFetching: 2,
          showPasswordRequest: state.showPasswordRequest);
    } on TimeoutException {
      logger.e('error reading profile photo');
      logger.d(fullName);
      logger.d(email);
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          name: fullName ?? 'no name',
          email: email ?? 'no data',
          statusFetching: 2,
          showPasswordRequest: state.showPasswordRequest);
    }
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: path,
        name: state.name,
        email: state.email,
        statusFetching: state.statusFetching,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setProfilePath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: path,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        statusFetching: state.statusFetching,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setName(String name) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: name,
        email: state.email,
        statusFetching: state.statusFetching,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setEmail(String email) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: email,
        statusFetching: state.statusFetching,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setStatus(int status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        statusFetching: status,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setShowPasswordRequest(bool status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        statusFetching: state.statusFetching,
        showPasswordRequest: status);
  }

  void onValidate(GlobalKey<FormState> formKey) async {
    final currentFormState = formKey.currentState;
    if (currentFormState == null) return;
    if (!currentFormState.validate()) return;
    currentFormState.save();

    setShowPasswordRequest(true);
  }

  void updateUserData(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setStatus(2);
      return;
    }
    final personalInfoData = state;
    final name = user.displayName;
    final email = user.email;
    if (name != null &&
        name.trim() == personalInfoData.name.trim() &&
        email != null &&
        email.trim() == personalInfoData.email.trim() &&
        personalInfoData.pathProfileTemporal.isEmpty) {
      setStatus(5);
      return;
    }
    setStatus(1);

    try {
      if (name != null && name != personalInfoData.name.trim()) {
        await user.updateDisplayName(personalInfoData.name);
      }

      if (email != null && email != personalInfoData.email.trim()) {
        final authCredential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(authCredential);
        await user.updateEmail(personalInfoData.email);
      }
    } on FirebaseAuthException catch (e) {
      logger.e('error changing email with ${e.code} and message $e');
      setStatus(3);

      return;
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty) {
      try {
        final userPhoto = storageRef
            .child("userImages/${FirebaseAuth.instance.currentUser!.uid}.jpg");

        await userPhoto.putFile(File(personalInfoData.pathProfileTemporal));
        final url = await userPhoto.getDownloadURL();
        setProfilePath(url);
        ref.read(mainScreenProvider.notifier).setAvatarLink(url);
        setStatus(4);
      } catch (e) {
        setStatus(3);

        logger.e('error');
        logger.e(e);
      }
    } else {
      setStatus(4);
    }
  }
}

final personalInfoProvider =
    NotifierProvider<PersonalInfoProvider, PersonalInfoData>(
        PersonalInfoProvider.new);

class PersonalInfoData {
  final String pathProfileUser;
  final String pathProfileTemporal;
  final String name;
  final String email;
  final int statusFetching;
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.pathProfileUser,
      required this.pathProfileTemporal,
      required this.name,
      required this.email,
      required this.statusFetching,
      required this.showPasswordRequest});
}
