import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/title_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchingStatus.noStarted,
        showPasswordRequest: false);
  }

  void setProfileTemporalPath(String path) async {
    state = PersonalInfoData(
        link: '',
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
        link: path,
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
        link: state.link,
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
        link: state.link,
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
        link: state.link,
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
        link: state.link,
        pathProfileTemporal: state.pathProfileTemporal,
        firstName: state.firstName,
        lastName: state.lastName,
        birthdate: state.birthdate,
        updatingStatus: updatingStatus,
        fetchingStatus: state.fetchingStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setFetchingStatus(PersonalInfoFetchingStatus fetchingStatus) {
    state = PersonalInfoData(
        link: state.link,
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
        link: state.link,
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
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: _isUpdating
            ? PersonalInfoUpdatingStatus.updating
            : PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchingStatus.noStarted,
        showPasswordRequest: state.showPasswordRequest);
  }

  String _firstName = "";
  String _lastName = "";
  String _birthdate = "";

  Future<void> fetchUserData() async {
    final uuid = ref.read(authServiceProvider).userUuid;

    setFetchingStatus(PersonalInfoFetchingStatus.processing);

    final statusConnection = ref.read(statusConnectionProvider);

    if (statusConnection == ConnectionStatus.noConnected) {
      final cachedUserDataList =
          await ref.read(localDBServiceProvider).readUserData(uuid ?? '');
      logger.d(cachedUserDataList);

      String firstName = '';
      String lastName = '';
      String avatarLink = '';
      String pathAvatar = '';
      String birthday = '';

      if (cachedUserDataList.isNotEmpty) {
        final cachedUserData = cachedUserDataList.first;
        firstName = cachedUserData['firstName'] as String;
        lastName = cachedUserData['lastName'] as String;
        avatarLink = cachedUserData['linkAvatar'] as String;
        pathAvatar = cachedUserData['pathAvatar'] as String;
        birthday = cachedUserData['birthday'] as String;
      }

      state = PersonalInfoData(
        link: avatarLink,
        pathProfileTemporal: pathAvatar,
        firstName: firstName,
        lastName: lastName,
        birthdate: birthday,
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        fetchingStatus: PersonalInfoFetchingStatus.success,
        showPasswordRequest: state.showPasswordRequest,
      );

      return;
    }

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
      _firstName = user.firstName;
      _lastName = user.lastName;
      _birthdate = user.birthday;

      state = PersonalInfoData(
          link: photoLink,
          pathProfileTemporal: '',
          firstName: user.firstName,
          lastName: user.lastName,
          birthdate: user.birthday,
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchingStatus.success,
          showPasswordRequest: state.showPasswordRequest);
    } on TimeoutException {
      state = PersonalInfoData(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: state.updatingStatus,
        fetchingStatus: PersonalInfoFetchingStatus.error,
        showPasswordRequest: state.showPasswordRequest,
      );
    } catch (e) {
      logger.e('error reading profile photo');
      state = PersonalInfoData(
          link: '',
          pathProfileTemporal: '',
          firstName: '',
          lastName: '',
          birthdate: '',
          updatingStatus: state.updatingStatus,
          fetchingStatus: PersonalInfoFetchingStatus.error,
          showPasswordRequest: state.showPasswordRequest);
    }
  }

  var _isUpdating = false;

  void updateUserData() async {
    if (state.pathProfileTemporal == "" &&
        _birthdate == state.birthdate &&
        _firstName == state.firstName &&
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

    String firstName = '';
    String lastName = '';
    String avatarLink = '';
    String pathAvatar = '';

    if (cachedUserDataList.isNotEmpty) {
      final cachedUserData = cachedUserDataList.first;
      firstName = cachedUserData['firstName'] as String;
      lastName = cachedUserData['lastName'] as String;
      avatarLink = cachedUserData['linkAvatar'] as String;
      pathAvatar = cachedUserData['pathAvatar'] as String;
    }

    try {
      await ref.read(cloudDBServiceProvider).updateUserData(userUuid, {
        'birthday': state.birthdate,
        'firstName': state.firstName,
        'lastName': state.lastName,
      });

      firstName = state.firstName;
      lastName = state.lastName;

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
        setUpdatingStatus(PersonalInfoUpdatingStatus.success);
        _isUpdating = false;
      } catch (e) {
        setUpdatingStatus(PersonalInfoUpdatingStatus.error);
        _isUpdating = false;
        logger.e('error');
        logger.e(e);
      }
    } else {
      setUpdatingStatus(PersonalInfoUpdatingStatus.success);
      _isUpdating = false;
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty) {
      await ref.read(localDBServiceProvider).insertUserData({
        'uuid': userUuid,
        'firstName': firstName,
        'lastName': lastName,
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

enum PersonalInfoFetchingStatus {
  noStarted('no started'),
  processing('processing'),
  error('error fetching data'),
  success('successful fetching data');

  const PersonalInfoFetchingStatus(this.message);
  final String message;
}

enum PersonalInfoUpdatingStatus {
  noStarted('no started'),
  updating('updating'),
  noUpdate('nothing to update'),
  success('successful updating process'),
  error('an error happened during updating process');

  const PersonalInfoUpdatingStatus(this.message);

  final String message;
}

class PersonalInfoData {
  final String link;
  final String pathProfileTemporal;
  final String firstName;
  final String lastName;
  final String birthdate;
  final PersonalInfoUpdatingStatus updatingStatus;
  final PersonalInfoFetchingStatus fetchingStatus;
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.link,
      required this.pathProfileTemporal,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.updatingStatus,
      required this.fetchingStatus,
      required this.showPasswordRequest});
}
