import 'package:kanji_for_n5_level_app/models/user.dart';

abstract class AuthService {
  String? userUuid;

  void setLoggedUser();

  Stream<String?> authStream();

  Future<StatusLoginRequest> singInWithEmailAndPassword(
      {required String email, required String password});

  Future<String> singUpWithEmailAndPassword(
      {required String email, required String password});

  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required String email});

  Future<(DeleteUserStatus, String)> deleteUser(
      {required String password,
      required String uuid,
      required UserData userData});

  Future<void> singOut();
}

enum StatusLoginRequest {
  notStarted,
  success,
  invalidCredentials,
  userNotFound,
  wrongPassword,
  tooManyRequest,
  error;
}

enum StatusResetPasswordRequest {
  success,
  invalidCredentials,
  emailInvalid,
  userNotFound,
  error;
}

enum DeleteUserStatus {
  success('Success'),
  notStarted('Not started'),
  wrongPassword('The password is invalid'),
  error('There was an error in the server');

  const DeleteUserStatus(this.message);
  final String message;
}

enum StatusCreatingUser {
  form,
  success,
  passwordMisMatch,
  invalidEmail,
  emailAlreadyInUse,
  operationNotAllowed,
  weakPassword,
  error;
}
