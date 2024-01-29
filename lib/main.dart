import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/cloud_repo/cloud_db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/cloud_repo/cloud_db_firestore_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/local_repo/db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/local_repo/db_sqflite_impl.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/api_repo/kanji_api_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/api_repo/kanji_kanji_alive_api_impl.dart';
import 'package:kanji_for_n5_level_app/auth_flow.dart';
import 'package:kanji_for_n5_level_app/providers/on_boarding_provider.dart';
import 'package:kanji_for_n5_level_app/screens/onBoarding_screen/my_page_viewer.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';

final dbFirebase = FirebaseFirestore.instance;

final KanjiApiService applicationApiService = AppAplicationApiService();
CloudDBService cloudDBService = FireStoreDBService();

final dio = Dio();
final logger = Logger();
final LocalDBService localDBService = SqliteDBService();
final AuthService authService = FirebaseSignInUser();

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF006687),
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
    final onBoardingData = ref.watch(onBoardingProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primary,
            foregroundColor: kDarkColorScheme.onPrimary,
            textStyle: Theme.of(context).textTheme.bodyLarge,
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
      home: (onBoardingData.isOnBoardingDone == null ||
              onBoardingData.isOnBoardingDone == false)
          ? const OnBoardingFlow()
          : const AuthFlow(),
    );
  }
}
