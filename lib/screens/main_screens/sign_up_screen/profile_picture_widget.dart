import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sign_up_screen/sign_up_provider.dart';

class ProfilePicture extends ConsumerWidget {
  ProfilePicture({
    super.key,
    required this.pathProfileUser,
    required this.setPathProfileUser,
  });

  final String pathProfileUser;
  final void Function(String path) setPathProfileUser;

  static const String pathAssetUser = 'assets/images/user.png';
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          width: 250,
          child: CircleAvatar(
            //radius: 80,
            maxRadius: 80,
            backgroundImage: pathProfileUser.isEmpty
                ? const AssetImage(pathAssetUser)
                : FileImage(File(pathProfileUser)) as ImageProvider,
          ),
        ),
        Positioned(
          bottom: 50,
          right: -0,
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                /* isScrollControlled: true,
                                  useSafeArea: true, */
                context: context,
                builder: (ctx) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          try {
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.camera);
                            if (photo != null) {
                              ref
                                  .read(singUpProvider.notifier)
                                  .setPathProfileUser(photo.path);
                            }
                          } on PlatformException catch (e) {
                            logger.e('Failed to pick image: $e');
                          }
                        },
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Take a picture'),
                      ),
                      const Divider(
                        height: 2,
                      ),
                      ListTile(
                        onTap: () async {
                          Navigator.of(context).pop();
                          try {
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (photo != null) {
                              /* ref
                                  .read(singUpProvider.notifier)
                                  .setPathProfileUser(photo.path); */
                              setPathProfileUser(photo.path);
                            }
                          } on PlatformException catch (e) {
                            logger.e('Failed to pick image: $e');
                          }
                        },
                        leading: const Icon(Icons.photo_size_select_actual),
                        title: const Text('Select a picture'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.image_search,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
