import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class AccountDetails extends ConsumerWidget {
  AccountDetails({super.key});

  final ImagePicker picker = ImagePicker();
  final String pathAssetUser = 'assets/images/user.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDetailsData = ref.watch(accountDetailsProvider);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'Sign Up to Kanji for N5',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(
        height: 40,
      ),
      InkWell(
        onTap: () async {
          try {
            final XFile? photo =
                await picker.pickImage(source: ImageSource.camera);
/*                       setState(() {
                        if (photo != null) {
                          pathProfileUser = photo.path;
                        }
                      }); */
          } on PlatformException catch (e) {
            logger.e('Failed to pick image: $e');
          }
        },
        child: CircleAvatar(
          radius: 80,
          backgroundImage: accountDetailsData.pathProfileUser.isEmpty
              ? AssetImage(pathAssetUser)
              : FileImage(File(accountDetailsData.pathProfileUser))
                  as ImageProvider,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
