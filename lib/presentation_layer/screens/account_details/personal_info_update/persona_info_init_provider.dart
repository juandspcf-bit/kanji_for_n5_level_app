import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

part 'persona_info_init_provider.g.dart';

@Riverpod(keepAlive: true)
class PersonaInfoInit extends _$PersonaInfoInit {
  String _firstName = "";
  String _lastName = "";
  String _birthdate = "";
  @override
  FutureOr<PersonalInfoData2> build() async {
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

      return PersonalInfoData2(
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
      _firstName = user.firstName;
      _lastName = user.lastName;
      _birthdate = user.birthday;

      return PersonalInfoData2(
        link: photoLink,
        pathProfileTemporal: '',
        firstName: user.firstName,
        lastName: user.lastName,
        birthdate: user.birthday,
      );
    } on TimeoutException {
      return PersonalInfoData2(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
      );
    } catch (e) {
      logger.e('error reading profile photo');
      return PersonalInfoData2(
        link: '',
        pathProfileTemporal: '',
        firstName: '',
        lastName: '',
        birthdate: '',
      );
    }
  }
}

class PersonalInfoData2 {
  final String link;
  final String pathProfileTemporal;
  final String firstName;
  final String lastName;
  final String birthdate;

  PersonalInfoData2({
    required this.link,
    required this.pathProfileTemporal,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
  });

  PersonalInfoData2 copyWith({
    String? link,
    String? pathProfileTemporal,
    String? firstName,
    String? lastName,
    String? birthdate,
  }) {
    return PersonalInfoData2(
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

    return other is PersonalInfoData2 &&
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
