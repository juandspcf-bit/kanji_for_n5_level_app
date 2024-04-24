import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_kanji_alive_api_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/cloud_repo/cloud_db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/cloud_repo/cloud_db_firestore_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/storage_repo/storage_db_imple.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final applicationApiServiceProvider = Provider<KanjiApiService>((ref) {
  return AppAplicationApiService();
});

final cloudDBServiceProvider = Provider<CloudDBService>((ref) {
  return FireStoreDBService();
});

final storageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});
