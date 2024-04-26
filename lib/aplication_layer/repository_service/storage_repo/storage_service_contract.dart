abstract class StorageService {
  Future<String> storeFile(
    String path,
    String uuid,
  );

  Future<String> getDownloadLink(
    String uuid,
  );

  Future<String> updateFile(
    String path,
    String uuid,
  );

  Future<void> deleteFile(
    String uuid,
  );
}
