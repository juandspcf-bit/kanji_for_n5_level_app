import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
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
    if (authService.userUuid == null || authService.userUuid == '') {
      setDeleteRequestStatus(DeleteRequestStatus.noStarted);
      setDeleteUserStatus(DeleteUserStatus.error);
      return;
    }

    setDeleteRequestStatus(DeleteRequestStatus.process);

    try {
      final (deleteUserStatus, uuid) = await authService.deleteUser(
        password: password,
        uuid: authService.userUuid ?? '',
      );

      if (deleteUserStatus == DeleteUserStatus.error) {
        setDeleteRequestStatus(DeleteRequestStatus.noStarted);
        setDeleteUserStatus(DeleteUserStatus.error);
        return;
      }

      await localDBService.deleteUserData(uuid);

      await cloudDBService.deleteQuizScoreData(uuid);
      await cloudDBService.deleteAllFavoritesCloudDB(uuid);

      try {
        storageService.deleteFile(uuid);
      } catch (e) {
        logger.e('error deleting user photo $e');
      }

      await Future.delayed(
        const Duration(seconds: 2),
      );
      setDeleteRequestStatus(DeleteRequestStatus.noStarted);
      setDeleteUserStatus(DeleteUserStatus.success);
    } on DeleteUserException catch (e) {
      logger.e(e);
      setDeleteRequestStatus(DeleteRequestStatus.noStarted);
      setDeleteUserStatus(DeleteUserStatus.error);
    }
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
