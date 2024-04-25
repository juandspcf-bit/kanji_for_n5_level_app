import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class ConnectionStatusIcon extends ConsumerWidget {
  const ConnectionStatusIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: connectivityData == ConnectionStatus.noConnected
          ? const Icon(Icons.cloud_off)
          : const Icon(Icons.cloud_done_rounded),
    );
  }
}
