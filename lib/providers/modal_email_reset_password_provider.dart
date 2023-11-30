import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModalEmailResetProvider extends Notifier<ModalEmailResetData> {
  @override
  ModalEmailResetData build() {
    return const ModalEmailResetData(email: '');
  }

  Future<void> onValidate() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: state.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
      } else if (e.code == 'auth/user-not-found') {}
    }
  }

  void setEmail(String email) {
    state = ModalEmailResetData(email: email);
  }
}

final modalEmailResetProvider =
    NotifierProvider<ModalEmailResetProvider, ModalEmailResetData>(
        ModalEmailResetProvider.new);

class ModalEmailResetData {
  final String email;

  const ModalEmailResetData({required this.email});
}
