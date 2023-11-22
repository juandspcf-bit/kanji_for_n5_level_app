import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kanji_for_n5_level_app/main_screens/login_screen.dart';
import 'package:kanji_for_n5_level_app/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/main_screens/sing_up_screen.dart';
import 'package:kanji_for_n5_level_app/providers/selection_navigation_bar_screen.dart';
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
        /*       cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.secondaryContainer,
            foregroundColor: kDarkColorScheme.onSecondaryContainer,
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
            logger.d('called');
            if (user != null) {
              logger.d('the uuid is ${user.uid}');
              ref.read(mainScreenProvider.notifier).initPage();
              return MainContent(uuid: user.uid);
            } else {
              logger.d('called loging form');
              return const LoginForm();
            }
          }),
    );
  }
}
