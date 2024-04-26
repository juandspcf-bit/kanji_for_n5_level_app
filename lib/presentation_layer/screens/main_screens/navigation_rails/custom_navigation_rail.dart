import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/account_details.dart';
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
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const AccountDetails();
          }));
        },
        child: CachedNetworkImage(
          height: 40,
          width: 40,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
            );
          },
          fit: BoxFit.cover,
          imageUrl: mainScreenData.avatarLink,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) =>
              Image.asset('assets/images/user.png'),
        ),
      ),
      trailing: null,
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
          icon: Icon(Icons.book),
          label: Text('Sections'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.favorite),
          label: Text('Favorites'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search),
          label: Text('Basic search'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.timeline),
          label: Text('Progress'),
        ),
      ],
    );
  }
}
