import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        firstName: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: false);
  }

  void resetData() {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        firstName: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: state.showPasswordRequest);
  }

  Future<void> getInitialPersonalInfoData() async {
    final uuid = authService.userUuid;
    String? fullName;
    try {
      setFetchingStatus(PersonalInfoFetchinStatus.processing);
      final user = await cloudDBService.readUserData(uuid ?? '');
      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      fullName = '${user.firstName} ${user.lastName}';

      final photoLink =
          await userPhoto.getDownloadURL().timeout(const Duration(seconds: 10));
      state = PersonalInfoData(
          pathProfileUser: photoLink,
          pathProfileTemporal: '',
          firstName: fullName,
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.success,
          showPasswordRequest: state.showPasswordRequest);
    } on TimeoutException {
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          firstName: fullName ?? 'no name',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    } catch (e) {
      logger.e('error reading profile photo');
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          firstName: fullName ?? '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    }
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: path,
        firstName: state.firstName,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setProfilePath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: path,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setName(String name) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: name,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setEmail(String email) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setUpdatingStatus(PersonalInfoUpdatingStatus updatingStatus) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        updatingStatus: updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setFetchingStatus(PersonalInfoFetchinStatus fetchingStatus) {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        updatingStatus: state.updatingStatus,
        fetchingStatus: fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setShowPasswordRequest(bool status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
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
    if (name != null &&
        name.trim() == personalInfoData.firstName.trim() &&
        personalInfoData.pathProfileTemporal.isEmpty) {
      setUpdatingStatus(PersonalInfoUpdatingStatus.noUpdate);
      return;
    }
    setUpdatingStatus(PersonalInfoUpdatingStatus.updating);

    try {
      if (name != null && name != personalInfoData.firstName.trim()) {
        await user.updateDisplayName(personalInfoData.firstName);
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
  final String firstName;
  final PersonalInfoUpdatingStatus updatingStatus;
  final PersonalInfoFetchinStatus fetchingStatus;
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.pathProfileUser,
      required this.pathProfileTemporal,
      required this.firstName,
      required this.updatingStatus,
      required this.fetchingStatus,
      required this.showPasswordRequest});
}
