abstract class CloudDBService {
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
