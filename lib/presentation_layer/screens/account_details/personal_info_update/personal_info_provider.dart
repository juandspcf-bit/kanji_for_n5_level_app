import 'dart:async';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "personal_info_provider.g.dart";

@Riverpod(keepAlive: true)
class PersonalInfo extends _$PersonalInfo {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
        updatingStatus: PersonalInfoUpdatingStatus.noStarted,
        showPasswordRequest: false);
  }

  void setProfileTemporalPath(String path) async {
    state = state.copyWith(link: "", pathProfileTemporal: path);
  }

  void setProfilePath(String link) async {
    state = state.copyWith(link: link);
  }

  void setFirstName(String name) async {
    state = state.copyWith(firstName: name);
  }

  void setLastName(String lastName) async {
    state = state.copyWith(lastName: lastName);
  }

  void setBirthdate(String birthdate) async {
    state = state.copyWith(birthdate: birthdate);
  }

  void setUpdatingStatus(PersonalInfoUpdatingStatus updatingStatus) async {
    state = state.copyWith(updatingStatus: updatingStatus);
  }

  void setFetchingStatus(PersonalInfoFetchingStatus fetchingStatus) {
    state = state.copyWith(fetchingStatus: fetchingStatus);
  }

  void setShowPasswordRequest(bool status) async {
    state = state.copyWith(showPasswordRequest: status);
  }

  bool isUpdating() {
    return _isUpdating;
  }

  var _isUpdating = false;

  void updateUserData() async {
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
    String birthday = "";
    String avatarLink = '';
    String pathAvatar = '';

    if (cachedUserDataList.isNotEmpty) {
      final cachedUserData = cachedUserDataList.first;

      firstName = cachedUserData['firstName'] as String;
      lastName = cachedUserData['lastName'] as String;
      birthday = cachedUserData['birthday'] as String;
      pathAvatar = cachedUserData['pathAvatar'] as String;
      avatarLink = cachedUserData['linkAvatar'] as String;

      if (firstName == state.firstName &&
          lastName == state.lastName &&
          birthday == state.birthdate &&
          personalInfoData.pathProfileTemporal.isEmpty) {
        logger.d("no update");
        setUpdatingStatus(PersonalInfoUpdatingStatus.noUpdate);
        _isUpdating = false;
        return;
      }
    }

    try {
      await ref.read(cloudDBServiceProvider).updateUserData(userUuid, {
        'birthday': state.birthdate,
        'firstName': state.firstName,
        'lastName': state.lastName,
      });

      firstName = state.firstName;
      lastName = state.lastName;
      birthday = state.birthdate;
    } catch (e) {
      logger.e(e);
      setUpdatingStatus(PersonalInfoUpdatingStatus.error);
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty) {
      try {
        avatarLink = await ref.read(storageServiceProvider).updateFile(
            personalInfoData.pathProfileTemporal,
            ref.read(authServiceProvider).userUuid ?? '');
        setProfilePath(avatarLink);
        ref.read(avatarMainScreenProvider.notifier).updateAvatar();
        setUpdatingStatus(PersonalInfoUpdatingStatus.success);
        _isUpdating = false;

        await ref.read(localDBServiceProvider).insertUserData({
          'uuid': userUuid,
          'firstName': firstName,
          'lastName': lastName,
          'linkAvatar': avatarLink,
          'pathAvatar': pathAvatar,
          'birthday': birthday
        });
        return;
      } catch (e) {
        await ref.read(localDBServiceProvider).insertUserData({
          'uuid': userUuid,
          'firstName': firstName,
          'lastName': lastName,
          'linkAvatar': avatarLink,
          'pathAvatar': pathAvatar,
          'birthday': birthday
        });
        setUpdatingStatus(PersonalInfoUpdatingStatus.error);
        _isUpdating = false;

        logger.e('error');
        logger.e(e);
        return;
      }
    } else {
      await ref.read(localDBServiceProvider).insertUserData({
        'uuid': userUuid,
        'firstName': firstName,
        'lastName': lastName,
        'linkAvatar': avatarLink,
        'pathAvatar': pathAvatar,
        'birthday': birthday
      });
      ref.read(avatarMainScreenProvider.notifier).updateAvatar();
      setUpdatingStatus(PersonalInfoUpdatingStatus.success);
      _isUpdating = false;

      return;
    }
  }

  void reset() {
    Timer(const Duration(milliseconds: 500), () {
      state = PersonalInfoData(
          link: '',
          pathProfileTemporal: '',
          firstName: '',
          lastName: '',
          birthdate: '',
          updatingStatus: PersonalInfoUpdatingStatus.noStarted,
          showPasswordRequest: false);
    });
  }
}

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
  final bool showPasswordRequest;

  PersonalInfoData(
      {required this.link,
      required this.pathProfileTemporal,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.updatingStatus,
      required this.showPasswordRequest});

  PersonalInfoData copyWith({
    String? link,
    String? pathProfileTemporal,
    String? firstName,
    String? lastName,
    String? birthdate,
    PersonalInfoUpdatingStatus? updatingStatus,
    PersonalInfoFetchingStatus? fetchingStatus,
    bool? showPasswordRequest,
  }) {
    return PersonalInfoData(
      link: link ?? this.link,
      pathProfileTemporal: pathProfileTemporal ?? this.pathProfileTemporal,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      showPasswordRequest: showPasswordRequest ?? this.showPasswordRequest,
    );
  }

  @override
  String toString() {
    return 'PersonalInfoData(link: $link, pathProfileTemporal: $pathProfileTemporal, firstName: $firstName, lastName: $lastName, birthdate: $birthdate, updatingStatus: $updatingStatus, showPasswordRequest: $showPasswordRequest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalInfoData &&
        other.link == link &&
        other.pathProfileTemporal == pathProfileTemporal &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthdate == birthdate &&
        other.updatingStatus == updatingStatus &&
        other.showPasswordRequest == showPasswordRequest;
  }

  @override
  int get hashCode {
    return link.hashCode ^
        pathProfileTemporal.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthdate.hashCode ^
        updatingStatus.hashCode ^
        showPasswordRequest.hashCode;
  }
}
