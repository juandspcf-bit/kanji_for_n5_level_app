abstract class SignInUser {
  Future<StatusLogingRequest> singInWithEmailAndPassword(
      {required String email, required String password});
}

enum StatusLogingRequest {
  notStarted('Not started'),
  success('Success'),
  invalidCredentials('Your email and password are wrong'),
  userNotFound('Your email was not found'),
  wrongPassword('Your password is wrong'),
  tooManyRequest('Access to this account has been temporarily disabled '
      'due to many failed login attempts. You can immediately restore it by '
      'resetting your password or you can try again later.'),
  error('An unexpected error has happened');

  const StatusLogingRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
