import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class ProfilePictureWidget extends ConsumerWidget {
  ProfilePictureWidget({
    super.key,
    required this.setPathProfileUser,
    required this.avatarWidget,
  });

  final void Function(String path) setPathProfileUser;
  final Widget avatarWidget;

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
          child: avatarWidget,
        ),
        Positioned(
          bottom: 50,
          right: -0,
          child: IconButton(
            onPressed: () {
              modalSelectionSourcePictureWidget(context, setPathProfileUser);
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

class CircleAvatarImage extends StatelessWidget {
  const CircleAvatarImage({
    super.key,
    required this.pathProfileUser,
    required this.pathAssetUser,
  });

  final String pathProfileUser;
  final String pathAssetUser;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: pathProfileUser.isEmpty
          ? AssetImage(pathAssetUser)
          : FileImage(File(pathProfileUser)) as ImageProvider,
    );
  }
}

class CircularAvatarNetworkImage extends StatelessWidget {
  const CircularAvatarNetworkImage({
    super.key,
    required this.pathProfileUser,
    required this.pathErrorImage,
  });

  final String pathProfileUser;
  final String pathErrorImage;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: pathProfileUser,
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          backgroundImage: imageProvider,
        );
      },
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => Image.asset(pathErrorImage),
    );
  }
}

void modalSelectionSourcePictureWidget(
    BuildContext context, void Function(String path) setPathProfileUser) {
  final ImagePicker picker = ImagePicker();

  void selecImageSource(
    ImageSource imageSource,
  ) async {
    Navigator.of(context).pop();
    try {
      final XFile? photo = await picker.pickImage(source: imageSource);
      if (photo != null) {
        setPathProfileUser(photo.path);
      }
    } on PlatformException catch (e) {
      logger.e('Failed to pick image: $e');
    }
  }

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              selecImageSource(
                ImageSource.camera,
              );
            },
            leading: const Icon(Icons.photo_camera),
            title: const Text('Take a picture'),
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () async {
              selecImageSource(
                ImageSource.gallery,
              );
            },
            leading: const Icon(Icons.photo_size_select_actual),
            title: const Text('Select a picture'),
          ),
        ],
      );
    },
  );
}
