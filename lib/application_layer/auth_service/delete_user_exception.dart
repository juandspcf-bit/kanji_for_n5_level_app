class DeleteUserException implements Exception {
  final DeleteErrorUserCode deleteErrorUserCode;
  final String message;

  DeleteUserException({
    required this.message,
    required this.deleteErrorUserCode,
  });

  @override
  String toString() {
    return 'Exception: $message';
  }
}

enum DeleteErrorUserCode {
  deleteErrorFavorites,
  deleteErrorQuizData,
  deleteErrorStorage,
  deleteErrorData,
  deleteErrorCached,
  deleteErrorAuth,
  deleteErrorUserData,
  deleteError
}
