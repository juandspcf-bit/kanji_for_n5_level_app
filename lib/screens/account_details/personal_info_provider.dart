import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/sing_in_user_firebase.dart';
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
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: false);
  }

  void resetData() {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        name: '',
        email: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: state.showPasswordRequest);
  }

  Future<void> getInitialPersonalInfoData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;
    final email = FirebaseAuth.instance.currentUser!.email;

    try {
      setFetchingStatus(PersonalInfoFetchinStatus.processing);

      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      logger.e('reading profile photo');

      final photoLink =
          await userPhoto.getDownloadURL().timeout(const Duration(seconds: 10));
      state = PersonalInfoData(
          pathProfileUser: photoLink,
          pathProfileTemporal: '',
          name: fullName ?? '',
          email: email ?? '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.success,
          showPasswordRequest: state.showPasswordRequest);
    } on TimeoutException {
      logger.e('time out exception');
      logger.d(fullName);
      logger.d(email);
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          name: fullName ?? 'no name',
          email: email ?? 'no data',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    } catch (e) {
      logger.e('error reading profile photo');
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          name: fullName ?? '',
          email: email ?? '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    }
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: path,
        name: state.name,
        email: state.email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setProfilePath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: path,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setName(String name) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: name,
        email: state.email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setEmail(String email) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setUpdatingStatus(PersonalInfoUpdatingStatus updatingStatus) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        updatingStatus: updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setFetchingStatus(PersonalInfoFetchinStatus fetchingStatus) {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setShowPasswordRequest(bool status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        name: state.name,
        email: state.email,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
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
      setUpdatingStatus(PersonalInfoUpdatingStatus.error);
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
      setUpdatingStatus(PersonalInfoUpdatingStatus.noUpdate);
      return;
    }
    setUpdatingStatus(PersonalInfoUpdatingStatus.updating);

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
      setUpdatingStatus(PersonalInfoUpdatingStatus.error);

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
        setUpdatingStatus(PersonalInfoUpdatingStatus.succes);
      } catch (e) {
        setUpdatingStatus(PersonalInfoUpdatingStatus.error);

        logger.e('error');
        logger.e(e);
      }
    } else {
      setUpdatingStatus(PersonalInfoUpdatingStatus.succes);
    }
  }
}

final personalInfoProvider =
    NotifierProvider<PersonalInfoProvider, PersonalInfoData>(
        PersonalInfoProvider.new);

enum PersonalInfoFetchinStatus {
  noStarted('no started'),
  processing('proccessing'),
  error('error fetching data'),
  success('succeful fetching data');

  const PersonalInfoFetchinStatus(this.message);
  final String message;
}

enum PersonalInfoUpdatingStatus {
  noStarted('no started'),
  updating('updating'),
  noUpdate('nothing to update'),
  succes('succeful updating process'),
  error('an error happend during updating process');

  const PersonalInfoUpdatingStatus(this.message);

  final String message;
}

class PersonalInfoData {
  final String pathProfileUser;
  final String pathProfileTemporal;
  final String name;
  final String email;
  final PersonalInfoUpdatingStatus updatingStatus;
  final PersonalInfoFetchinStatus fetchingStatus;
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.pathProfileUser,
      required this.pathProfileTemporal,
      required this.name,
      required this.email,
      required this.updatingStatus,
      required this.fetchingStatus,
      required this.showPasswordRequest});
}
