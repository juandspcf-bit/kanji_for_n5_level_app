import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/deep_translate_translation_api_service.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_kanji_alive_api_impl.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/translation_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/cloud_repo/cloud_db_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/cloud_repo/cloud_db_service_firebase.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/local_repo/local_db_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/local_repo/local_db_service_sqflite.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/storage_repo/storage_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/storage_repo/storage_service_firebase.dart';
import 'package:kanji_for_n5_level_app/application_layer/toast_service/material_snack_bar_service.dart';
import 'package:kanji_for_n5_level_app/application_layer/toast_service/toast_service_contract.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final translationApiServiceProvider = Provider<TranslationApiService>((ref) {
  return DeepTranslateTranslationApiService();
});

final kanjiApiServiceProvider = Provider<KanjiApiService>((ref) {
  return KanjiAliveApiService(
    translationApiService: ref.read(translationApiServiceProvider),
  );
});

final cloudDBServiceProvider = Provider<CloudDBService>((ref) {
  return FireStoreDBService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return FirebaseStorageService();
});

final localDBServiceProvider = Provider<LocalDBService>((ref) {
  return SQLiteDBService();
});

final toastServiceProvider = Provider<ToastServiceContract>((ref) {
  return MaterialSnackBarService();
});
