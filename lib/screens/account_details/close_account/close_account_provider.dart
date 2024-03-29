import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class CloseAccountProvider extends Notifier<CloseAccountData> {
  @override
  CloseAccountData build() {
    return CloseAccountData(
      deleteRequestStatus: DeleteRequestStatus.noStarted,
      deleteUserStatus: DeleteUserStatus.notStarted,
      showPasswordRequest: false,
    );
  }

  void resetStatus() {
    state = CloseAccountData(
      deleteRequestStatus: DeleteRequestStatus.noStarted,
      deleteUserStatus: DeleteUserStatus.notStarted,
      showPasswordRequest: false,
    );
  }

  void setShowPasswordRequest(bool showPasswordRequest) {
    state = CloseAccountData(
        deleteRequestStatus: state.deleteRequestStatus,
        deleteUserStatus: state.deleteUserStatus,
        showPasswordRequest: showPasswordRequest);
  }

  void setDeleteRequestStatus(DeleteRequestStatus deleteRequestStatus) {
    state = CloseAccountData(
        deleteRequestStatus: deleteRequestStatus,
        deleteUserStatus: state.deleteUserStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void setDeleteUserStatus(DeleteUserStatus deleteUserStatus) {
    state = CloseAccountData(
        deleteRequestStatus: state.deleteRequestStatus,
        deleteUserStatus: deleteUserStatus,
        showPasswordRequest: state.showPasswordRequest);
  }

  void deleteUser({required String password}) async {
    setDeleteRequestStatus(DeleteRequestStatus.process);
    //TODO execute the deletion succefuly even if the connection is lost
    final (deleteUserStatus, uuid) =
        await authService.deleteUser(password: password);
    await localDBService.deleteUserData(uuid);

    await cloudDBService.deleteQuizScoreData(uuid);
    await cloudDBService.deleteAllFavoritesCloudDB(uuid);

    final userPhoto = storageRef.child("userImages/$uuid.jpg");
    await userPhoto.delete().onError(
        (error, stackTrace) => logger.e('error deleting user photo $error'));

    await Future.delayed(
      const Duration(seconds: 2),
    );
    setDeleteRequestStatus(DeleteRequestStatus.noStarted);
    setDeleteUserStatus(deleteUserStatus);
  }
}

final closeAccountProvider =
    NotifierProvider<CloseAccountProvider, CloseAccountData>(
        CloseAccountProvider.new);

enum DeleteRequestStatus {
  noStarted('no started'),
  process('process');

  const DeleteRequestStatus(this.message);
  final String message;
}

class CloseAccountData {
  final DeleteUserStatus deleteUserStatus;
  final DeleteRequestStatus deleteRequestStatus;
  final bool showPasswordRequest;

  CloseAccountData(
      {required this.deleteUserStatus,
      required this.deleteRequestStatus,
      required this.showPasswordRequest});
}
