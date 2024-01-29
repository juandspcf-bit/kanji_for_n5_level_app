import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/cloud_repo/cloud_db_contract.dart';
import 'package:kanji_for_n5_level_app/repositories/cloud_database/db_firestore_functions/db_favorites_firestore.dart';

class FireStoreDBService extends CloudDBService {
  @override
  Future<void> insertFavoriteCloudDB(
    String kanjiCharacter,
    int timeStamp,
    String uuid,
  ) {
    return insertFavorite(kanjiCharacter, timeStamp, uuid);
  }
}
