import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/cloud_repo/cloud_db_contract.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/repositories/cloud_database/db_firestore_functions/db_favorites_firestore.dart';
import 'package:kanji_for_n5_level_app/repositories/cloud_database/db_firestore_functions/db_user_data_firestore.dart';

class FireStoreDBService extends CloudDBService {
  @override
  Future<void> insertFavoriteCloudDB(
    String kanjiCharacter,
    int timeStamp,
    String uuid,
  ) {
    return insertFavorite(kanjiCharacter, timeStamp, uuid);
  }

  @override
  Future<void> deleteFavoriteCloudDB(String kanjiCharacter, String uuid) {
    return deleteFavorite(
      kanjiCharacter,
      uuid,
    );
  }

  @override
  Future<List<Favorite>> loadFavoritesCloudDB(
    String uuid,
  ) {
    return loadFavoriteKanjis(uuid);
  }

  @override
  Future<void> addUserData(String email, String uuid) {
    return insertUserData(
      email,
      uuid,
    );
  }
}
