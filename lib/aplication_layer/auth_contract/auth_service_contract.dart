abstract class AuthService {
  String? userUuid;

  void setLoggedUser();

  Future<StatusLogingRequest> singInWithEmailAndPassword(
      {required String email, required String password});

  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required String email});

  Future<(DeleteUserStatus, String)> deleteUser(
      {required String password, required String uuid});

  Future<void> singOut();
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

enum StatusResetPasswordRequest {
  success('Success'),
  invalidCredentials('Invalid credentials'),
  emailInvalid('The email is invalid'),
  userNotFound('There is no corresponding user for this email'),
  error('There was an error in the server');

  const StatusResetPasswordRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}

enum DeleteUserStatus {
  success('Success'),
  notStarted('Not started'),
  wrongPassword('The password is invalid'),
  error('There was an error in the server');

  const DeleteUserStatus(this.message);
  final String message;
}
