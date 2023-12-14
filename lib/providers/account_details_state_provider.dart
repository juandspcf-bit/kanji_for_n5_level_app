import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        name: '',
        email: '',
        statusFetching: 0);
  }

  void resetData() {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        name: '',
        email: '',
        statusFetching: 0);
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
      );
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
      );
    }
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: path,
        name: state.name,
        email: state.email,
        statusFetching: state.statusFetching);
  }

  void setProfilePath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: path,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        statusFetching: state.statusFetching);
  }

  void setName(String name) async {
    //await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: name,
        email: state.email,
        statusFetching: state.statusFetching);
  }

  void setEmail(String email) async {
    //await FirebaseAuth.instance.currentUser!.updateEmail(email);
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: email,
        statusFetching: state.statusFetching);
  }

  void setStatus(int status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        statusFetching: status);
  }

  void onValidate(GlobalKey<FormState> formKey, WidgetRef ref) async {
    final currentFormState = formKey.currentState;
    if (currentFormState == null) return;
    if (!currentFormState.validate()) return;
    currentFormState.save();
    final accountDetailsData = ref.read(personalInfoProvider);
    setStatus(1);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(accountDetailsData.name);
    await FirebaseAuth.instance.currentUser!
        .updateEmail(accountDetailsData.email);
    if (accountDetailsData.pathProfileTemporal.isNotEmpty) {
      try {
        final userPhoto = storageRef
            .child("userImages/${FirebaseAuth.instance.currentUser!.uid}.jpg");

        await userPhoto.putFile(File(accountDetailsData.pathProfileTemporal));
        final url = await userPhoto.getDownloadURL();
        setProfilePath(url);
        ref.read(mainScreenProvider.notifier).setAvatarLink(url);
      } catch (e) {
        logger.e('error');
        logger.e(e);
      }
    }
    setName(accountDetailsData.name);
    setEmail(accountDetailsData.email);
    setStatus(2);
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

  PersonalInfoData(
      {required this.pathProfileUser,
      required this.pathProfileTemporal,
      required this.name,
      required this.email,
      required this.statusFetching});
}
