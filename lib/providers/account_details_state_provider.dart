import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class PersonalInfoProvider extends Notifier<PersonalInfoData> {
  @override
  PersonalInfoData build() {
    return PersonalInfoData(pathProfileUser: '', birthdayDate: DateTime.now());
  }

  Future<void> getAppBarData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    logger.d(fullName);

    try {
      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      final photoLink = await userPhoto.getDownloadURL();
      state = PersonalInfoData(
          pathProfileUser: photoLink, birthdayDate: state.birthdayDate);
    } catch (e) {
      logger.e('error reading profile photo');
      state = PersonalInfoData(
          pathProfileUser: '', birthdayDate: state.birthdayDate);
    }
  }

  void setBirthdayDate(DateTime date) {
    state = PersonalInfoData(
        pathProfileUser: state.pathProfileUser, birthdayDate: date);
  }
}

final personalInfoProvider =
    NotifierProvider<PersonalInfoProvider, PersonalInfoData>(
        PersonalInfoProvider.new);

class PersonalInfoData {
  final String pathProfileUser;
  final DateTime birthdayDate;

  PersonalInfoData({required this.pathProfileUser, required this.birthdayDate});
}
