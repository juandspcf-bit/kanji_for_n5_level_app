import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/storage_repo/storage_service_contract.dart';

final storageRef = FirebaseStorage.instance.ref();

class FirebaseStorageService extends StorageService {
  @override
  Future<String> storeFile(String path, String uuid) async {
    final userPhoto = storageRef.child("userImages/$uuid.jpg");
    await userPhoto.putFile(File(path));
    return await userPhoto.getDownloadURL();
  }

  @override
  Future<String> getDownloadLink(String uuid) async {
    final userPhoto = storageRef.child("userImages/$uuid.jpg");

    return await userPhoto
        .getDownloadURL()
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<String> updateFile(String path, String uuid) async {
    final userPhoto = storageRef.child("userImages/$uuid.jpg");
    await userPhoto.putFile(File(path));
    return await userPhoto.getDownloadURL();
  }

  @override
  Future<void> deleteFile(String uuid) async {
    try {
      final userPhoto = storageRef.child("userImages/$uuid.jpg");
      return await userPhoto.delete();
    } on FirebaseException catch (e) {
      throw DeleteUserException(
          message: e.code,
          deleteErrorUserCode: DeleteErrorUserCode.deleteErrorStorage);
    } catch (e) {
      throw DeleteUserException(
          message: 'error deleting user favorites from cloud db',
          deleteErrorUserCode: DeleteErrorUserCode.deleteErrorStorage);
    }
  }
}
