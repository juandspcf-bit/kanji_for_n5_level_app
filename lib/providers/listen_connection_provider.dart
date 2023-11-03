import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityResult =
    StreamProvider.autoDispose<ConnectivityResult?>((ref) {
  final firebaseAuth = ref.watch(coneccectionProvider);

  return firebaseAuth.onConnectivityChanged;
});

// provider to access the FirebaseAuth instance
final coneccectionProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});
