import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class AccountDetailsProvider extends Notifier<AccountDetailsData> {
  @override
  AccountDetailsData build() {
    return AccountDetailsData(pathProfileUser: '', link: '');
  }

  Future<void> getAppBarData() async {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    logger.d(fullName);

    try {
      final userPhoto = storageRef.child("userImages/$uuid.jpg");

      final photoLink = await userPhoto.getDownloadURL();
      state = AccountDetailsData(pathProfileUser: photoLink, link: '');
    } catch (e) {
      logger.e('error reading profile photo');
      state = AccountDetailsData(pathProfileUser: '', link: '');
    }
  }
}

final accountDetailsProvider =
    NotifierProvider<AccountDetailsProvider, AccountDetailsData>(
        AccountDetailsProvider.new);

class AccountDetailsData {
  final String pathProfileUser;
  final String link;

  AccountDetailsData({required this.pathProfileUser, required this.link});
}
