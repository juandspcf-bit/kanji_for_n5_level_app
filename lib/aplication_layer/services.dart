import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_kanji_alive_api_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/cloud_repo/cloud_db_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/cloud_repo/cloud_db_service_firestore.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/local_repo/db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/local_repo/db_sqflite_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/storage_repo/storage_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/storage_repo/storage_db_imple.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/toast_service/material_snack_bar_service.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/toast_service/toats_service_contract.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final applicationApiServiceProvider = Provider<KanjiApiService>((ref) {
  return AppAplicationApiService();
});

final cloudDBServiceProvider = Provider<CloudDBService>((ref) {
  return FireStoreDBService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return FirebaseStorageService();
});

final localDBServiceProvider = Provider<LocalDBService>((ref) {
  return SqliteDBService();
});

final toastServiceProvider = Provider<ToastServiceContract>((ref) {
  return MaterialSnackBarService(); //ToastificationService();
});
