abstract class ResetEmail {}

enum StatusResetPasswordRequest {
  success('Success'),
  invalidCredentials('Invalid credentials'),
  emailInvalid('The email is invalid'),
  userNotFound('There is no corresponding user for this email'),
  error('The was an error in the server');

  const StatusResetPasswordRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
