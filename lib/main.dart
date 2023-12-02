import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'firebase_options.dart';

final dbFirebase = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final streamAuth = FirebaseAuth.instance.userChanges();

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF008490),
);

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primary,
            foregroundColor: kDarkColorScheme.onPrimary,
          ),
        ),
        /*       cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),

         appBarTheme: const AppBarTheme()
            .copyWith(backgroundColor: Color.fromARGB(255, 14, 46, 77)),*/
      ),
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: StreamBuilder(
          stream: streamAuth,
          builder: (ctx, snapShot) {
            final user = snapShot.data;

            if (user != null) {
              final connectionWifiState = ref.watch(statusConnectionProvider);

              return FutureBuilder(
                future: connectionWifiState == ConnectivityResult.none
                    ? ref.read(mainScreenProvider.notifier).initPageOffline()
                    : ref.read(mainScreenProvider.notifier).initPageOnline(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  final connectionStatus = snapShot.connectionState;
                  logger.d('The connection status is $connectionStatus');
                  if (connectionStatus == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (connectionStatus == ConnectionState.done ||
                      connectionStatus == ConnectionState.active) {
                    return MainContent(uuid: user.uid);
                  } else {
                    return const Center(child: Text('error'));
                  }
                },
              );
            } else {
              logger.d('called loging form');
              return const LoginForm();
            }
          }),
    );
  }
}
