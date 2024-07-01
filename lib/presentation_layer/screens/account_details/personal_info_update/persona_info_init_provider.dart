import 'dart:async';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

part 'persona_info_init_provider.g.dart';

@Riverpod(keepAlive: false)
class PersonaInfoInit extends _$PersonaInfoInit {
  @override
  FutureOr<PersonalInfoDataInit> build() async {
    if (ref.read(personalInfoProvider.notifier).isUpdating()) {
      final dataUpdate = ref.read(personalInfoProvider);
      return PersonalInfoDataInit(
        link: dataUpdate.link,
        pathProfileTemporal: dataUpdate.pathProfileTemporal,
        firstName: dataUpdate.firstName,
        lastName: dataUpdate.lastName,
        birthdate: dataUpdate.birthdate,
      );
    }
    final uuid = ref.read(authServiceProvider).userUuid;

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

      return PersonalInfoDataInit(
        link: avatarLink,
        pathProfileTemporal: pathAvatar,
        firstName: firstName,
        lastName: lastName,
        birthdate: birthday,
      );
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

      return PersonalInfoDataInit(
        link: photoLink,
        pathProfileTemporal: '',
        firstName: user.firstName,
        lastName: user.lastName,
        birthdate: user.birthday,
      );
    } on TimeoutException {
      return PersonalInfoDataInit(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
      );
    } catch (e) {
      logger.e('error reading profile photo');
      return PersonalInfoDataInit(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
      );
    }
  }
}

class PersonalInfoDataInit {
  final String link;
  final String pathProfileTemporal;
  final String firstName;
  final String lastName;
  final String birthdate;

  PersonalInfoDataInit({
    required this.link,
    required this.pathProfileTemporal,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
  });

  PersonalInfoDataInit copyWith({
    String? link,
    String? pathProfileTemporal,
    String? firstName,
    String? lastName,
    String? birthdate,
  }) {
    return PersonalInfoDataInit(
      link: link ?? this.link,
      pathProfileTemporal: pathProfileTemporal ?? this.pathProfileTemporal,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  @override
  String toString() {
    return 'PersonalInfoData2(link: $link, pathProfileTemporal: $pathProfileTemporal, firstName: $firstName, lastName: $lastName, birthdate: $birthdate, )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalInfoDataInit &&
        other.link == link &&
        other.pathProfileTemporal == pathProfileTemporal &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthdate == birthdate;
  }

  @override
  int get hashCode {
    return link.hashCode ^
        pathProfileTemporal.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthdate.hashCode;
  }
}
