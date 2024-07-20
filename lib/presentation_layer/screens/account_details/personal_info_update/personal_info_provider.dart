import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_provider.dart';

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

  void updateState({
    String? link,
    String? pathProfileTemporal,
    String? firstName,
    String? lastName,
    String? birthdate,
    PersonalInfoUpdatingStatus? updatingStatus,
    PersonalInfoFetchingStatus? fetchingStatus,
    bool? showPasswordRequest,
  }) {
    state = PersonalInfoData(
      link: link ?? state.link,
      pathProfileTemporal: pathProfileTemporal ?? state.pathProfileTemporal,
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      birthdate: birthdate ?? state.birthdate,
      updatingStatus: updatingStatus ?? state.updatingStatus,
      showPasswordRequest: showPasswordRequest ?? state.showPasswordRequest,
    );
  }

  bool isUpdating() {
    return _isUpdating;
  }

  var _isUpdating = false;
  String _pathProfileTemporal = "";

  void updateUserData() async {
    final uuid = ref.read(authServiceProvider).userUuid;
    if (uuid == null) {
      updateState(updatingStatus: PersonalInfoUpdatingStatus.error);
      _isUpdating = false;
      return;
    }
    final personalInfoData = state;

    updateState(updatingStatus: PersonalInfoUpdatingStatus.updating);
    _isUpdating = true;

    final cachedUserDataList =
        await ref.read(localDBServiceProvider).readUserData(uuid);

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
          (personalInfoData.pathProfileTemporal.isEmpty ||
              personalInfoData.pathProfileTemporal == _pathProfileTemporal)) {
        updateState(updatingStatus: PersonalInfoUpdatingStatus.noUpdate);
        _isUpdating = false;
        return;
      }
    }

    final errorUpdatingBasicData = await updateBasicUserData(uuid);
    if (!errorUpdatingBasicData) {
      firstName = state.firstName;
      lastName = state.lastName;
      birthday = state.birthdate;
    }

    if (personalInfoData.pathProfileTemporal.isNotEmpty &&
        personalInfoData.pathProfileTemporal != _pathProfileTemporal) {
      _pathProfileTemporal = personalInfoData.pathProfileTemporal;
      try {
        await Isolate.run(
          () {
            Image? image = decodeImage(
                io.File(personalInfoData.pathProfileTemporal)
                    .readAsBytesSync());

            if (image != null) {
              final width = image.width;
              final height = image.height;

              final aspectRatio = height / width;

              Image thumbnail = copyResize(image,
                  width: 1024, height: (1024 * aspectRatio).toInt());

              final file = io.File(personalInfoData.pathProfileTemporal);
              file.writeAsBytesSync(encodeJpg(thumbnail, quality: 50));
            }
          },
        );

        avatarLink = await ref.read(storageServiceProvider).updateFile(
            personalInfoData.pathProfileTemporal,
            ref.read(authServiceProvider).userUuid ?? '');
        ref.read(avatarMainScreenProvider.notifier).refreshAvatar();

        if (errorUpdatingBasicData) {
          updateState(
              updatingStatus: PersonalInfoUpdatingStatus.partialUpdateError);
        } else {
          updateState(updatingStatus: PersonalInfoUpdatingStatus.success);
        }
        _isUpdating = false;

        final pathBase = (await getApplicationDocumentsDirectory()).path;
        final pathAvatar = '$pathBase/$uuid.jpg';

        await ref.read(localDBServiceProvider).insertUserData({
          'uuid': uuid,
          'firstName': firstName,
          'lastName': lastName,
          'linkAvatar': avatarLink,
          'pathAvatar': pathAvatar,
          'birthday': birthday
        });
        return;
      } catch (e) {
        await ref.read(localDBServiceProvider).insertUserData({
          'uuid': uuid,
          'firstName': firstName,
          'lastName': lastName,
          'linkAvatar': avatarLink,
          'pathAvatar': pathAvatar,
          'birthday': birthday
        });
        if (errorUpdatingBasicData) {
          updateState(
              updatingStatus: PersonalInfoUpdatingStatus.partialUpdateError);
        } else {
          updateState(updatingStatus: PersonalInfoUpdatingStatus.success);
        }
        _isUpdating = false;

        logger.e('error');
        logger.e(e);
        return;
      }
    } else {
      await ref.read(localDBServiceProvider).insertUserData({
        'uuid': uuid,
        'firstName': firstName,
        'lastName': lastName,
        'linkAvatar': avatarLink,
        'pathAvatar': pathAvatar,
        'birthday': birthday
      });
      if (errorUpdatingBasicData) {
        updateState(
            updatingStatus: PersonalInfoUpdatingStatus.partialUpdateError);
      } else {
        updateState(updatingStatus: PersonalInfoUpdatingStatus.success);
      }
      _isUpdating = false;

      return;
    }
  }

  Future<bool> updateBasicUserData(String uuid) async {
    try {
      await ref.read(cloudDBServiceProvider).updateUserData(uuid, {
        'birthday': state.birthdate,
        'firstName': state.firstName,
        'lastName': state.lastName,
      });
      return false;
    } catch (e) {
      logger.e(e);
      return true;
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
  error('an error happened during updating process'),
  partialUpdateError("part of the data was not updated correctly");

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
