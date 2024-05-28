import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class InitMainContent extends ConsumerWidget {
  const InitMainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(statusConnectionProvider) == ConnectionStatus.noConnected
          ? ref.read(mainScreenProvider.notifier).initAppOffline()
          : ref.read(mainScreenProvider.notifier).initAppOnline(),
      builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
        final connectionStatus = snapShot.connectionState;
        if (connectionStatus == ConnectionState.waiting) {
          return const Scaffold(
            body: ProcessProgress(
              message: 'Loading',
            ),
          );
        } else if (connectionStatus == ConnectionState.done ||
            connectionStatus == ConnectionState.active) {
          return const MainContent();
        } else {
          return const Center(child: Text('error'));
        }
      },
    );
  }
}
