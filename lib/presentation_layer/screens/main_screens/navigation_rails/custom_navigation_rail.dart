import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

class CustomNavigationRail extends ConsumerWidget with StatusDBStoringDialogs {
  const CustomNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    return NavigationRail(
      selectedIndex: mainScreenData.selection.index,
      groupAlignment: 0.0,
      onDestinationSelected: (int index) {
        ref.read(toastServiceProvider).dismiss(context);

        ref
            .read(mainScreenProvider.notifier)
            .selectPage(index, context, statusDBStoringDialog);
      },
      labelType: NavigationRailLabelType.all,
      leading: const AvatarMainScreenLandScape(),
      trailing: null,
      destinations: <NavigationRailDestination>[
        NavigationRailDestination(
          icon: const Icon(Icons.book),
          label: Text(context.l10n.sectionNavBar),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.favorite),
          label: Text(context.l10n.favoritesNavBar),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.search),
          label: Text(context.l10n.basicSearchNavBar),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.timeline),
          label: Text(context.l10n.progressNavBar),
        ),
      ],
    );
  }
}
