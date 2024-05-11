import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/title_main_screen_provider.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: false);
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: path,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setProfilePath(String path) async {
    state = PersonalInfoData(
        pathProfileUser: path,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setName(String name) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: name,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setLastName(String lastName) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setBirthdate(String birthdate) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setUpdatingStatus(PersonalInfoUpdatingStatus updatingStatus) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setFetchingStatus(PersonalInfoFetchinStatus fetchingStatus) {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setShowPasswordRequest(bool status) async {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: state.updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: status);
  }

  void resetData() {
    state = PersonalInfoData(
        pathProfileUser: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: _isUpdating
            ? PersonalInfoUpdatingStatus.updating
            : PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchinStatus.noStarted,
        showPasswordRequest: state.showPasswordRequest);
  }

  String _firtsName = "";
  String _lastName = "";
  String _birthdate = "";

  Future<void> fetchUserData() async {
    final uuid = ref.read(authServiceProvider).userUuid;

    setFetchingStatus(PersonalInfoFetchinStatus.processing);

    String photoLink = '';
    try {
      photoLink =
          await ref.read(storageServiceProvider).getDownloadLink(uuid ?? '');
    } catch (e) {
      logger.e(e);
    }

    try {
      final user =
          await ref.read(cloudDBServiceProvider).readUserData(uuid ?? '');
      _firtsName = user.firstName;
      _lastName = user.lastName;
      _birthdate = user.birthday;

      state = PersonalInfoData(
          pathProfileUser: photoLink,
          pathProfileTemporal: '',
          firstName: user.firstName,
          lastName: user.lastName,
          birthdate: user.birthday,
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.success,
          showPasswordRequest: state.showPasswordRequest);
    } on TimeoutException {
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          firstName: '',
          lastName: '',
          birthdate: '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    } catch (e) {
      logger.e('error reading profile photo');
      state = PersonalInfoData(
          pathProfileUser: '',
          pathProfileTemporal: '',
          firstName: '',
          lastName: '',
          birthdate: '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchinStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    }
  }

  var _isUpdating = false;

  void updateUserData() async {
    if (state.pathProfileTemporal == "" &&
        _birthdate == state.birthdate &&
        _firtsName == state.firstName &&
        _lastName == state.lastName) {
      setUpdatingStatus(PersonalInfoUpdatingStatus.noUpdate);
      _isUpdating = false;
      return;
    }

    final userUuid = ref.read(authServiceProvider).userUuid;
    if (userUuid == null) {
      setUpdatingStatus(PersonalInfoUpdatingStatus.error);
      _isUpdating = false;
      return;
    }
    final personalInfoData = state;

    setUpdatingStatus(PersonalInfoUpdatingStatus.updating);
    _isUpdating = true;

    final cachedUserDataList =
        await ref.read(localDBServiceProvider).readUserData(userUuid);

    String fullName = '';
    String avatarLink = '';
    String pathAvatar = '';

    if (cachedUserDataList.isNotEmpty) {
      final cachedUserData = cachedUserDataList.first;
      fullName = cachedUserData['fullName'] as String;
      avatarLink = cachedUserData['linkAvatar'] as String;
      pathAvatar = cachedUserData['pathAvatar'] as String;
    }

    try {
      await ref.read(cloudDBServiceProvider).updateUserData(userUuid, {
        'birthday': state.birthdate,
        'firstName': state.firstName,
        'lastName': state.lastName,
      });

      fullName = '${state.firstName} ${state.lastName}';
      ref.read(titleMainScreenProvider.notifier).getTitle();
    } catch (e) {
      logger.e(e);
      setUpdatingStatus(PersonalInfoUpdatingStatus.error);
      _isUpdating = false;
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty) {
      try {
        avatarLink = await ref.read(storageServiceProvider).updateFile(
            personalInfoData.pathProfileTemporal,
            ref.read(authServiceProvider).userUuid ?? '');
        setProfilePath(avatarLink);
        ref.read(avatarMainScreenProvider.notifier).getLink();
        setUpdatingStatus(PersonalInfoUpdatingStatus.succes);
        _isUpdating = false;
      } catch (e) {
        setUpdatingStatus(PersonalInfoUpdatingStatus.error);
        _isUpdating = false;
        logger.e('error');
        logger.e(e);
      }
    } else {
      setUpdatingStatus(PersonalInfoUpdatingStatus.succes);
      _isUpdating = false;
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty) {
      await ref.read(localDBServiceProvider).insertUserData({
        'uuid': userUuid,
        'fullName': fullName,
        'linkAvatar': avatarLink,
        'pathAvatar': pathAvatar,
        'birthday': state.birthdate
      });
    } else {}
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
  final String lastName;
  final String birthdate;
  final PersonalInfoUpdatingStatus updatingStatus;
  final PersonalInfoFetchinStatus fetchingStatus;
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.pathProfileUser,
      required this.pathProfileTemporal,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.updatingStatus,
      required this.fetchingStatus,
      required this.showPasswordRequest});
}
