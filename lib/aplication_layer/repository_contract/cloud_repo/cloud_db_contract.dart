import 'package:kanji_for_n5_level_app/models/favorite.dart';

abstract class CloudDBService {
  Future<List<Favorite>> loadFavoritesCloudDB(
    String uuid,
  );

  Future<void> insertFavoriteCloudDB(
    String kanjiCharacter,
    int timeStamp,
    String uuid,
  );

  Future<void> deleteFavoriteCloudDB(
    String kanjiCharacter,
    String uuid,
  );
}
