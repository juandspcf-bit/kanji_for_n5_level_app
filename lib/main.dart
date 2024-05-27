import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/auth_flow/auth_flow.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/onBoarding_screen/on_boarding_screen.dart';
import 'package:kanji_for_n5_level_app/providers/on_boarding_provider.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final logger = Logger();

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
    ref.read(lottieFilesProvider.notifier).initLottieFile();

    final onBoardingData = ref.watch(onBoardingProvider);
    Future.delayed(const Duration(milliseconds: 200));

    ref.read(statusConnectionProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      darkTheme: getDarkTheme(context),
      theme: getLightTheme(),
      themeMode: ThemeMode.dark,
      home: (onBoardingData.isOnBoardingDone == null ||
              onBoardingData.isOnBoardingDone == false)
          ? const OnBoardingScreen()
          : const AuthFlow(),
    );
  }
}
